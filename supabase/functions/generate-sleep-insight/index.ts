// supabase/functions/generate-sleep-insight/index.ts
// Supabase Edge Function: AI 睡眠洞察生成器
// 部署: supabase functions deploy generate-sleep-insight

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface SleepRecord {
  date: string;
  duration_minutes: number;
  sleep_quality: number;
  deep_sleep_minutes: number;
  light_sleep_minutes: number;
  rem_sleep_minutes: number;
  awake_minutes: number;
  avg_heart_rate: number | null;
  avg_spo2: number | null;
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    // Verify auth
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(JSON.stringify({ error: "No auth" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const { data: { user }, error: authError } = await supabase.auth.getUser(
      authHeader.replace("Bearer ", "")
    );
    if (authError || !user) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Fetch last 7 days of sleep records
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    const { data: records, error: dbError } = await supabase
      .from("sleep_records")
      .select(
        "date, duration_minutes, sleep_quality, deep_sleep_minutes, light_sleep_minutes, rem_sleep_minutes, awake_minutes, avg_heart_rate, avg_spo2"
      )
      .eq("user_id", user.id)
      .gte("date", sevenDaysAgo.toISOString().split("T")[0])
      .order("date", { ascending: false });

    if (dbError || !records || records.length === 0) {
      return new Response(
        JSON.stringify({ message: "Not enough data for insights" }),
        {
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // Calculate statistics
    const stats = calculateStats(records as SleepRecord[]);

    // Generate insights using OpenAI (if available)
    const openAIKey = Deno.env.get("OPENAI_API_KEY");
    let insights: Array<{ title: string; content: string; type: string }> = [];

    if (openAIKey) {
      insights = await generateAIInsights(openAIKey, stats, records as SleepRecord[]);
    } else {
      // Rule-based fallback
      insights = generateRuleBasedInsights(stats);
    }

    // Save insights to database
    if (insights.length > 0) {
      const insightRows = insights.map((i) => ({
        user_id: user.id,
        insight_type: i.type,
        title: i.title,
        content: i.content,
        data: { stats },
        generated_at: new Date().toISOString(),
      }));

      await supabase.from("sleep_insights").insert(insightRows);
    }

    return new Response(JSON.stringify({ insights, stats }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});

function calculateStats(records: SleepRecord[]) {
  const n = records.length;
  const avgHours =
    records.reduce((sum, r) => sum + (r.duration_minutes || 0), 0) / n / 60;
  const avgQuality =
    records.reduce((sum, r) => sum + (r.sleep_quality || 0), 0) / n;
  const avgDeepPct =
    records.reduce(
      (sum, r) =>
        sum + (r.deep_sleep_minutes / (r.duration_minutes || 1)) * 100,
      0
    ) / n;
  const avgRemPct =
    records.reduce(
      (sum, r) =>
        sum + (r.rem_sleep_minutes / (r.duration_minutes || 1)) * 100,
      0
    ) / n;
  const avgHR =
    records.filter((r) => r.avg_heart_rate).reduce((sum, r) => sum + r.avg_heart_rate!, 0) /
    records.filter((r) => r.avg_heart_rate).length || null;
  const avgSpo2 =
    records.filter((r) => r.avg_spo2).reduce((sum, r) => sum + r.avg_spo2!, 0) /
    records.filter((r) => r.avg_spo2).length || null;

  return { n, avgHours, avgQuality, avgDeepPct, avgRemPct, avgHR, avgSpo2 };
}

async function generateAIInsights(
  apiKey: string,
  stats: ReturnType<typeof calculateStats>,
  records: SleepRecord[]
): Promise<Array<{ title: string; content: string; type: string }>> {
  const prompt = `你是一位专业睡眠健康顾问。根据以下用户的过去7天睡眠数据，生成3条简洁、个性化的中文睡眠洞察建议。

睡眠统计:
- 平均睡眠时长: ${stats.avgHours.toFixed(1)} 小时
- 平均质量评分: ${stats.avgQuality.toFixed(1)} / 5
- 平均深睡比例: ${stats.avgDeepPct.toFixed(1)}%
- 平均 REM 比例: ${stats.avgRemPct.toFixed(1)}%
${stats.avgHR ? `- 平均心率: ${stats.avgHR.toFixed(0)} bpm` : ""}
${stats.avgSpo2 ? `- 平均血氧: ${stats.avgSpo2.toFixed(1)}%` : ""}
- 追踪天数: ${stats.n}

要求: 输出 JSON 数组，每条包含 type("weekly_report"|"pattern"|"recommendation"), title(10字内), content(50字内)`;

  const response = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${apiKey}`,
    },
    body: JSON.stringify({
      model: "gpt-4o-mini",
      messages: [{ role: "user", content: prompt }],
      response_format: { type: "json_object" },
      max_tokens: 500,
    }),
  });

  const data = await response.json();
  const content = JSON.parse(data.choices[0].message.content);
  return Array.isArray(content.insights) ? content.insights : content;
}

function generateRuleBasedInsights(
  stats: ReturnType<typeof calculateStats>
): Array<{ title: string; content: string; type: string }> {
  const insights = [];

  // Duration insight
  if (stats.avgHours < 6) {
    insights.push({
      type: "recommendation",
      title: "⚠️ 睡眠严重不足",
      content: `本周平均睡眠 ${stats.avgHours.toFixed(1)} 小时，低于建议的 7 小时。长期睡眠不足影响免疫力和认知功能。`,
    });
  } else if (stats.avgHours >= 7 && stats.avgHours <= 9) {
    insights.push({
      type: "weekly_report",
      title: "✅ 睡眠时长达标",
      content: `本周平均睡眠 ${stats.avgHours.toFixed(1)} 小时，处于理想范围（7-9小时），继续保持！`,
    });
  }

  // Deep sleep insight
  if (stats.avgDeepPct < 15) {
    insights.push({
      type: "recommendation",
      title: "💡 深睡比例偏低",
      content: `深睡平均占比 ${stats.avgDeepPct.toFixed(0)}%，低于理想值 15-25%。建议减少睡前咖啡因和屏幕时间。`,
    });
  }

  // Quality insight
  if (stats.avgQuality >= 4) {
    insights.push({
      type: "pattern",
      title: "🌟 睡眠质量优秀",
      content: `主观质量评分 ${stats.avgQuality.toFixed(1)}/5，表现优秀。你的睡眠习惯非常健康！`,
    });
  }

  return insights.slice(0, 3);
}
