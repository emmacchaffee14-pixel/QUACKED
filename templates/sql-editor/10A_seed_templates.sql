-- QUACKED: Seed templates table with 10 archetypes
-- Run this in Supabase SQL Editor
 
-- Break-Even Investment
INSERT INTO templates (
  name, description, archetype, content_type,
  firm_compatibility, difficulty_range, recommended_difficulty,
  formula, skills_tested, business_contexts, question_patterns,
  variables, solution_logic, key_insight, common_mistakes,
  framework_soundbite, archetype_tags
) VALUES (
  'Break-Even Investment',
  'Determine whether an investment pays off financially.',
  'break_even_investment',
  'drill',
  ARRAY['McKinsey', 'Bain', 'BCG'],
  ARRAY['duckling', 'billable_bird', 'fully_quacked'],
  'duckling',
  'Break-even units = Fixed investment / Contribution margin per unit. Break-even time = Investment / Annual profit uplift.',
  ARRAY['break_even_analysis', 'contribution_margin', 'payback_period', 'investment_math'],
  ARRAY['retailer evaluating a new store opening', 'manufacturer assessing a new product launch', 'restaurant group opening a new location', 'tech company launching a new feature requiring engineering investment', 'gym operator considering a new equipment purchase'],
  ARRAY['How many units must be sold for this investment to break even?', 'How long until the investment pays for itself?', 'At what volume does this project become profitable?', 'Does the expected volume clear the break-even threshold?'],
  '{"investment_cost": {"min": 100000, "max": 10000000, "step": 100000, "unit": "$"}, "revenue_per_unit": {"min": 15, "max": 600, "step": 5, "unit": "$"}, "variable_cost_per_unit": {"min": 5, "max": 400, "step": 5, "unit": "$"}, "additional_fixed_costs_pa": {"min": 10000, "max": 1000000, "step": 10000, "unit": "$/year"}, "expected_units_per_year": {"min": 1000, "max": 200000, "step": 1000, "unit": "units/year"}}',
  ARRAY['Step 1: Calculate contribution margin = revenue_per_unit - variable_cost_per_unit', 'Step 2: Calculate annual profit from investment = (expected_units × contribution_margin) - additional_fixed_costs_pa', 'Step 3: Calculate break-even units = investment_cost / contribution_margin', 'Step 4: Calculate break-even time = investment_cost / annual_profit_from_investment', 'Step 5: Assess viability — payback under 3 years is typically acceptable in most industries'],
  'Break-even is not the goal — it''s the floor. The real question is how much return exceeds break-even over the investment''s life.',
  ARRAY['Using revenue instead of contribution margin in the denominator', 'Forgetting additional fixed costs that come with the investment', 'Confusing break-even units with break-even time'],
  'Break-even tells you the minimum — how long until you stop losing. What matters is the return above break-even.',
  ARRAY['manufacturing', 'retail', 'tech', 'real estate', 'energy', 'healthcare']
);
 
-- Capacity Expansion
INSERT INTO templates (
  name, description, archetype, content_type,
  firm_compatibility, difficulty_range, recommended_difficulty,
  formula, skills_tested, business_contexts, question_patterns,
  variables, solution_logic, key_insight, common_mistakes,
  framework_soundbite, archetype_tags
) VALUES (
  'Capacity Expansion',
  'Evaluate whether investment in expansion makes financial sense.',
  'capacity_expansion',
  'drill',
  ARRAY['McKinsey', 'Bain', 'BCG'],
  ARRAY['billable_bird', 'fully_quacked'],
  'billable_bird',
  'Net benefit = (Additional units × Contribution margin × Years) - Capex - (Additional fixed costs × Years)',
  ARRAY['capex_analysis', 'payback_period', 'contribution_margin', 'capacity_math'],
  ARRAY['manufacturer evaluating a new production line', 'logistics firm considering a second distribution center', 'hospital system assessing a new ward build-out', 'data center operator planning capacity expansion', 'brewery deciding whether to add fermentation tanks'],
  ARRAY['Does the incremental profit justify the capital investment?', 'What is the payback period on this expansion?', 'How many years until the investment breaks even?', 'Should the client expand now or wait for higher utilization?'],
  '{"capex_required": {"min": 500000, "max": 20000000, "step": 250000, "unit": "$"}, "additional_capacity_units": {"min": 500, "max": 10000, "step": 250, "unit": "units/year"}, "contribution_margin": {"min": 20, "max": 300, "step": 10, "unit": "$/unit"}, "additional_fixed_costs": {"min": 50000, "max": 2000000, "step": 25000, "unit": "$/year"}, "expected_utilization": {"min": 0.6, "max": 0.9, "step": 0.05, "unit": "%"}, "analysis_years": {"min": 3, "max": 10, "step": 1, "unit": "years"}}',
  ARRAY['Step 1: Calculate effective additional units = additional_capacity_units × expected_utilization', 'Step 2: Calculate annual incremental profit = effective_units × contribution_margin - additional_fixed_costs', 'Step 3: Calculate total profit over period = annual_incremental_profit × analysis_years', 'Step 4: Calculate net return = total_profit - capex_required', 'Step 5: Calculate payback period = capex_required / annual_incremental_profit'],
  'Never evaluate capex on revenue alone. The question is always: does the incremental profit, over time, justify the upfront spend?',
  ARRAY['Using full capacity instead of expected utilization', 'Forgetting additional fixed costs that come with expansion (staff, rent, maintenance)', 'Not calculating payback period — just total return'],
  'Capex only makes sense if payback period is acceptable and incremental returns exceed cost of capital. Start with payback.',
  ARRAY['manufacturing', 'real estate', 'logistics', 'hospitals', 'energy']
);
 
-- Customer Growth
INSERT INTO templates (
  name, description, archetype, content_type,
  firm_compatibility, difficulty_range, recommended_difficulty,
  formula, skills_tested, business_contexts, question_patterns,
  variables, solution_logic, key_insight, common_mistakes,
  framework_soundbite, archetype_tags
) VALUES (
  'Customer Growth',
  'Analyze acquisition, retention, churn, or customer growth dynamics.',
  'customer_growth',
  'drill',
  ARRAY['McKinsey', 'Bain', 'BCG'],
  ARRAY['billable_bird', 'fully_quacked'],
  'billable_bird',
  'Net customers = Starting_base + New_acquired - Churned. LTV = ARPU × (1 / churn_rate)',
  ARRAY['churn_math', 'LTV', 'customer_economics', 'growth_dynamics'],
  ARRAY['SaaS platform with rising churn offsetting new signups', 'subscription box company modeling growth trajectory', 'telecom operator analyzing prepaid customer base', 'fintech app tracking monthly active user growth', 'gym chain evaluating membership retention economics'],
  ARRAY['Is the business growing or shrinking its customer base net of churn?', 'What is the lifetime value of a customer at current churn rates?', 'Does the LTV justify the current cost of acquisition?', 'How many months until the customer base stabilizes?'],
  '{"starting_customer_base": {"min": 5000, "max": 500000, "step": 5000, "unit": "customers"}, "monthly_acquisition_rate": {"min": 0.02, "max": 0.15, "step": 0.01, "unit": "% of base"}, "monthly_churn_rate": {"min": 0.01, "max": 0.08, "step": 0.005, "unit": "% of base"}, "arpu_monthly": {"min": 15, "max": 500, "step": 5, "unit": "$/month"}, "cac": {"min": 50, "max": 2000, "step": 50, "unit": "$/customer"}, "analysis_months": {"min": 6, "max": 24, "step": 3, "unit": "months"}}',
  ARRAY['Step 1: Calculate monthly new customers = starting_customer_base × monthly_acquisition_rate', 'Step 2: Calculate monthly churned customers = starting_customer_base × monthly_churn_rate', 'Step 3: Calculate net monthly growth = new_customers - churned_customers', 'Step 4: Calculate ending base = starting_base + (net_monthly_growth × analysis_months)', 'Step 5: Calculate LTV = arpu_monthly / monthly_churn_rate', 'Step 6: Calculate LTV:CAC ratio = LTV / cac'],
  'Growth without retention is a leaky bucket. Always check if acquisition rate exceeds churn rate before declaring a growth story.',
  ARRAY['Ignoring compounding — churn and acquisition compound monthly, not linearly', 'Forgetting to calculate LTV:CAC — the most important unit economics metric', 'Treating churn as an absolute number rather than a rate'],
  'Net growth = acquisition minus churn. If churn exceeds acquisition, growth is impossible regardless of marketing spend.',
  ARRAY['SaaS', 'subscriptions', 'retail', 'fintech', 'media', 'telecoms']
);
 
-- Market Share Shift
INSERT INTO templates (
  name, description, archetype, content_type,
  firm_compatibility, difficulty_range, recommended_difficulty,
  formula, skills_tested, business_contexts, question_patterns,
  variables, solution_logic, key_insight, common_mistakes,
  framework_soundbite, archetype_tags
) VALUES (
  'Market Share Shift',
  'Assess competitive position changes and revenue impact of share gains or losses.',
  'market_share_shift',
  'drill',
  ARRAY['McKinsey', 'Bain', 'BCG'],
  ARRAY['billable_bird', 'fully_quacked'],
  'billable_bird',
  'Revenue = Market size × Market share. Share gain revenue = Market size × share_delta. Competitive impact = share_lost × competitor_revenue_per_point.',
  ARRAY['market_share_math', 'competitive_dynamics', 'revenue_decomposition', 'market_sizing'],
  ARRAY['consumer goods brand losing shelf space to a new entrant', 'telco defending market share against a low-cost disruptor', 'automotive OEM gaining share in an emerging segment', 'retail bank responding to a fintech competitor', 'airline capturing share on a rival''s key route'],
  ARRAY['What is the revenue impact of gaining X points of market share?', 'How much profit is at risk if the client loses share to the competitor?', 'What share gain is needed to offset the proposed investment?', 'How does the client''s revenue change as the market grows and share shifts?'],
  '{"total_market_size": {"min": 500000000, "max": 50000000000, "step": 500000000, "unit": "$"}, "current_market_share": {"min": 0.05, "max": 0.45, "step": 0.01, "unit": "%"}, "share_change": {"min": -0.08, "max": 0.1, "step": 0.01, "unit": "% points"}, "market_growth_rate": {"min": -0.05, "max": 0.2, "step": 0.01, "unit": "%"}, "contribution_margin_pct": {"min": 0.2, "max": 0.65, "step": 0.05, "unit": "%"}}',
  ARRAY['Step 1: Calculate current revenue = total_market_size × current_market_share', 'Step 2: Calculate new market size = total_market_size × (1 + market_growth_rate)', 'Step 3: Calculate new market share = current_market_share + share_change', 'Step 4: Calculate new revenue = new_market_size × new_market_share', 'Step 5: Calculate revenue delta = new_revenue - current_revenue', 'Step 6: Calculate profit impact = revenue_delta × contribution_margin_pct'],
  'Share gains in a growing market compound — you''re gaining on a larger base. Share gains in a shrinking market may still mean absolute revenue decline.',
  ARRAY['Calculating share gain on the old market size, not the new (grown) market', 'Treating share points as absolute rather than percentage of total', 'Forgetting to apply contribution margin to get profit impact from revenue change'],
  'Market share tells you your relative position. Multiply by market size to get what actually matters: absolute revenue.',
  ARRAY['strategy', 'competitive response', 'market entry', 'pricing', 'M&A']
);
 
-- Market Sizing
INSERT INTO templates (
  name, description, archetype, content_type,
  firm_compatibility, difficulty_range, recommended_difficulty,
  formula, skills_tested, business_contexts, question_patterns,
  variables, solution_logic, key_insight, common_mistakes,
  framework_soundbite, archetype_tags
) VALUES (
  'Market Sizing',
  'Estimate total market demand or opportunity.',
  'market_sizing',
  'drill',
  ARRAY['McKinsey', 'Bain', 'BCG'],
  ARRAY['billable_bird', 'fully_quacked'],
  'billable_bird',
  'TAM = Population × Penetration_rate × Purchase_frequency × Average_spend',
  ARRAY['market_sizing', 'estimation', 'segmentation', 'order_of_magnitude'],
  ARRAY['private equity firm evaluating a new market entry', 'startup pitching TAM to investors', 'consulting team assessing expansion opportunity', 'corporate strategy team sizing an adjacent market', 'venture fund screening a potential investment'],
  ARRAY['What is the total addressable market for this product?', 'How large is the opportunity if the client captures its target share?', 'What annual revenue is available in this segment?', 'Is this market large enough to justify the investment?'],
  '{"target_population": {"min": 500000, "max": 50000000, "step": 500000, "unit": "people"}, "penetration_rate": {"min": 0.05, "max": 0.6, "step": 0.05, "unit": "%"}, "purchase_frequency": {"min": 1, "max": 52, "step": 1, "unit": "times/year"}, "avg_spend_per_purchase": {"min": 10, "max": 500, "step": 10, "unit": "$"}, "addressable_segment": {"min": 0.3, "max": 0.85, "step": 0.05, "unit": "% of population"}}',
  ARRAY['Step 1: Identify addressable population = target_population × addressable_segment', 'Step 2: Apply penetration rate = addressable_population × penetration_rate', 'Step 3: Calculate annual spend per user = purchase_frequency × avg_spend_per_purchase', 'Step 4: Calculate TAM = penetrating_users × annual_spend_per_user'],
  'Market sizing is about defensible assumptions, not precision. Show your logic clearly — the interviewer is testing your structure, not your arithmetic.',
  ARRAY['Sizing the total population instead of the addressable segment', 'Forgetting purchase frequency — confusing annual vs per-transaction spend', 'Not sanity-checking the output against known benchmarks'],
  'Top-down or bottom-up — pick one, state your assumptions, and sanity-check the output. The logic matters more than the number.',
  ARRAY['strategy', 'market entry', 'new product', 'investor pitch', 'PE due diligence']
);
 
-- Pricing Optimization
INSERT INTO templates (
  name, description, archetype, content_type,
  firm_compatibility, difficulty_range, recommended_difficulty,
  formula, skills_tested, business_contexts, question_patterns,
  variables, solution_logic, key_insight, common_mistakes,
  framework_soundbite, archetype_tags
) VALUES (
  'Pricing Optimization',
  'Determine pricing impact on revenue and profit.',
  'pricing_optimization',
  'drill',
  ARRAY['McKinsey', 'Bain', 'BCG'],
  ARRAY['billable_bird', 'fully_quacked'],
  'billable_bird',
  'Optimal price tests: Revenue = Price × Volume(Price). Profit-maximizing when MR = MC.',
  ARRAY['pricing', 'elasticity', 'revenue_math', 'margin_math'],
  ARRAY['airline evaluating a fare increase on a key route', 'SaaS company testing a price rise on its core plan', 'hotel group repricing its weekend room rates', 'consumer goods brand considering a list price increase', 'retailer evaluating promotional discount depth'],
  ARRAY['Should the client raise prices, and by how much?', 'What is the profit impact of a price increase given expected volume loss?', 'At what price does profit begin to decline?', 'Does the margin gain per unit outweigh the volume loss?'],
  '{"current_price": {"min": 20, "max": 800, "step": 10, "unit": "$"}, "current_volume": {"min": 1000, "max": 50000, "step": 500, "unit": "units"}, "price_increase_pct": {"min": 0.05, "max": 0.25, "step": 0.05, "unit": "%"}, "price_elasticity": {"min": -2.0, "max": -0.3, "step": 0.1, "unit": "elasticity"}, "variable_cost_per_unit": {"min": 8, "max": 400, "step": 10, "unit": "$"}, "fixed_costs": {"min": 20000, "max": 500000, "step": 10000, "unit": "$"}}',
  ARRAY['Step 1: Calculate new price = current_price × (1 + price_increase_pct)', 'Step 2: Calculate volume change = current_volume × (price_elasticity × price_increase_pct)', 'Step 3: Calculate new volume = current_volume + volume_change', 'Step 4: Calculate current profit = (current_price - variable_cost_per_unit) × current_volume - fixed_costs', 'Step 5: Calculate new profit = (new_price - variable_cost_per_unit) × new_volume - fixed_costs', 'Step 6: Calculate profit delta to determine if price increase is worthwhile'],
  'A price increase only wins if the margin gain per unit outweighs the volume lost. Always check both sides.',
  ARRAY['Forgetting that elasticity applies to % change, not absolute change', 'Applying elasticity to revenue instead of volume', 'Ignoring variable costs when evaluating profit impact'],
  'Price up means margin per unit rises but volume falls. The question is always: which effect is bigger?',
  ARRAY['retail', 'SaaS', 'consumer goods', 'hospitality', 'airlines']
);
 
-- Productivity Improvement
INSERT INTO templates (
  name, description, archetype, content_type,
  firm_compatibility, difficulty_range, recommended_difficulty,
  formula, skills_tested, business_contexts, question_patterns,
  variables, solution_logic, key_insight, common_mistakes,
  framework_soundbite, archetype_tags
) VALUES (
  'Productivity Improvement',
  'Increase labor, machine, or asset productivity.',
  'productivity_improvement',
  'drill',
  ARRAY['McKinsey', 'Bain', 'BCG'],
  ARRAY['duckling', 'billable_bird', 'fully_quacked'],
  'duckling',
  'Productivity = Output / Input. Gain = (New output - Old output) × value per unit. Labor saving = headcount_reduction × cost_per_employee.',
  ARRAY['productivity_math', 'labor_economics', 'efficiency_gains', 'unit_economics'],
  ARRAY['logistics firm rolling out route optimization software', 'manufacturer introducing lean production techniques', 'bank streamlining back-office processing workflows', 'retailer retraining store staff on new checkout process', 'call center deploying AI-assisted response tools'],
  ARRAY['What is the annual value of the proposed productivity improvement?', 'How many FTEs could be redeployed if productivity increases by X%?', 'What additional output is generated with the same headcount?', 'Is the productivity gain large enough to justify the implementation cost?'],
  '{"current_output_per_worker": {"min": 10, "max": 500, "step": 10, "unit": "units/day"}, "productivity_improvement": {"min": 0.05, "max": 0.4, "step": 0.05, "unit": "%"}, "number_of_workers": {"min": 10, "max": 2000, "step": 10, "unit": "workers"}, "cost_per_worker_annual": {"min": 25000, "max": 150000, "step": 5000, "unit": "$/year"}, "value_per_unit": {"min": 2, "max": 100, "step": 2, "unit": "$/unit"}, "working_days_per_year": {"min": 220, "max": 260, "step": 5, "unit": "days"}}',
  ARRAY['Step 1: Calculate new output per worker = current_output × (1 + productivity_improvement)', 'Step 2: Calculate total additional output = (new_output - current_output) × number_of_workers × working_days', 'Step 3: Calculate revenue value of additional output = additional_output × value_per_unit', 'Step 4: Calculate equivalent headcount saving = improvement_pct × number_of_workers', 'Step 5: Calculate annual labor cost saving = headcount_saving × cost_per_worker_annual'],
  'Productivity gains can be captured as either more output with the same headcount, or the same output with fewer people. Which the client wants determines the recommendation.',
  ARRAY['Applying productivity improvement to revenue directly instead of output units', 'Forgetting to multiply by working days to get annual figures', 'Not distinguishing between output gains and cost savings — they''re different recommendations'],
  'Productivity improvement has two levers: you can take it as volume or as cost. The right answer depends on whether demand exceeds supply.',
  ARRAY['manufacturing', 'logistics', 'services', 'healthcare', 'retail operations']
);
 
-- Profitability Decline
INSERT INTO templates (
  name, description, archetype, content_type,
  firm_compatibility, difficulty_range, recommended_difficulty,
  formula, skills_tested, business_contexts, question_patterns,
  variables, solution_logic, key_insight, common_mistakes,
  framework_soundbite, archetype_tags
) VALUES (
  'Profitability Decline',
  'Revenue, costs, or margins are deteriorating.',
  'profitability_decline',
  'drill',
  ARRAY['McKinsey', 'Bain', 'BCG'],
  ARRAY['duckling', 'billable_bird', 'fully_quacked'],
  'duckling',
  'Profit = Revenue - Fixed Costs - Variable Costs = (Price × Volume) - Fixed - (Variable_cost_per_unit × Volume)',
  ARRAY['profitability', 'margin_math', 'cost_structure', 'revenue_decomposition'],
  ARRAY['retail chain experiencing margin compression', 'manufacturer facing rising input costs', 'SaaS business with increasing churn', 'restaurant group with declining same-store sales', 'consumer goods brand losing pricing power'],
  ARRAY['Why has profit declined despite stable revenue?', 'Is the decline driven by price, volume, or cost?', 'How much profit has been lost versus the prior period?', 'What is the size of the profitability gap the client needs to close?'],
  '{"price_per_unit": {"min": 20, "max": 500, "step": 10, "unit": "$"}, "volume_current": {"min": 5000, "max": 80000, "step": 1000, "unit": "units"}, "volume_prior": {"min": 6000, "max": 90000, "step": 1000, "unit": "units"}, "variable_cost_per_unit": {"min": 8, "max": 300, "step": 5, "unit": "$"}, "fixed_costs": {"min": 50000, "max": 800000, "step": 25000, "unit": "$"}, "price_prior": {"min": 22, "max": 550, "step": 10, "unit": "$"}}',
  ARRAY['Step 1: Calculate current revenue = price_per_unit × volume_current', 'Step 2: Calculate prior revenue = price_prior × volume_prior', 'Step 3: Calculate current profit = revenue_current - fixed_costs - (variable_cost_per_unit × volume_current)', 'Step 4: Calculate prior profit = revenue_prior - fixed_costs - (variable_cost_per_unit × volume_prior)', 'Step 5: Calculate profit delta and identify whether it is price-driven, volume-driven, or cost-driven'],
  'Always decompose profit decline into price × volume × cost. Never diagnose before you know which lever moved.',
  ARRAY['Forgetting fixed costs don''t move with volume', 'Conflating revenue decline with profit decline', 'Not checking if cost per unit changed, not just total costs'],
  'Profit = Price × Volume − Costs. One of those three moved. Find which one before recommending anything.',
  ARRAY['retail', 'manufacturing', 'SaaS', 'consumer goods', 'industrials']
);
 
-- Supply Chain Efficiency
INSERT INTO templates (
  name, description, archetype, content_type,
  firm_compatibility, difficulty_range, recommended_difficulty,
  formula, skills_tested, business_contexts, question_patterns,
  variables, solution_logic, key_insight, common_mistakes,
  framework_soundbite, archetype_tags
) VALUES (
  'Supply Chain Efficiency',
  'Improve logistics, fulfillment, or operational efficiency.',
  'supply_chain_efficiency',
  'drill',
  ARRAY['McKinsey', 'Bain', 'BCG'],
  ARRAY['billable_bird', 'fully_quacked'],
  'billable_bird',
  'Total logistics cost = (Units × Cost_per_unit_shipped) + Warehousing + Spoilage/waste. Saving = current - optimized.',
  ARRAY['cost_per_unit', 'logistics_math', 'efficiency_gains', 'operations'],
  ARRAY['e-commerce retailer optimizing last-mile delivery costs', 'food manufacturer reducing spoilage in cold chain', 'pharma distributor consolidating warehouse network', 'fast fashion brand renegotiating freight contracts', 'grocery chain improving inventory turnover'],
  ARRAY['How much can annual logistics costs be reduced through optimization?', 'What is the total saving from reducing waste and shipping cost per unit?', 'Which part of the supply chain offers the highest cost reduction opportunity?', 'What is the annual saving from the proposed network consolidation?'],
  '{"units_shipped_per_year": {"min": 10000, "max": 2000000, "step": 10000, "unit": "units"}, "current_cost_per_unit": {"min": 2, "max": 50, "step": 1, "unit": "$"}, "optimized_cost_per_unit": {"min": 1, "max": 40, "step": 1, "unit": "$"}, "warehousing_cost_annual": {"min": 50000, "max": 5000000, "step": 50000, "unit": "$"}, "waste_rate_current": {"min": 0.02, "max": 0.15, "step": 0.01, "unit": "%"}, "waste_rate_optimized": {"min": 0.005, "max": 0.08, "step": 0.005, "unit": "%"}, "unit_value": {"min": 5, "max": 200, "step": 5, "unit": "$/unit"}}',
  ARRAY['Step 1: Calculate current shipping cost = units_shipped × current_cost_per_unit', 'Step 2: Calculate optimized shipping cost = units_shipped × optimized_cost_per_unit', 'Step 3: Calculate current waste cost = units_shipped × waste_rate_current × unit_value', 'Step 4: Calculate optimized waste cost = units_shipped × waste_rate_optimized × unit_value', 'Step 5: Calculate total annual saving = (shipping savings) + (waste savings)'],
  'Supply chain savings compound across volume. A $2/unit improvement sounds small until you multiply it by 500,000 units.',
  ARRAY['Calculating savings on a per-unit basis without scaling to total volume', 'Forgetting waste/spoilage as a cost category', 'Not separating fixed warehousing from variable shipping costs'],
  'Every cost in a supply chain is either fixed or variable. Separate them first, then find which lever moves the most at scale.',
  ARRAY['retail', 'FMCG', 'manufacturing', 'e-commerce', 'food & beverage', 'pharma']
);
 
-- Throughput Bottleneck
INSERT INTO templates (
  name, description, archetype, content_type,
  firm_compatibility, difficulty_range, recommended_difficulty,
  formula, skills_tested, business_contexts, question_patterns,
  variables, solution_logic, key_insight, common_mistakes,
  framework_soundbite, archetype_tags
) VALUES (
  'Throughput Bottleneck',
  'Operations cannot support demand growth.',
  'throughput_bottleneck',
  'drill',
  ARRAY['McKinsey', 'Bain', 'BCG'],
  ARRAY['billable_bird', 'fully_quacked'],
  'billable_bird',
  'Max throughput = min(capacity_per_stage) × utilization × operating_hours',
  ARRAY['throughput', 'capacity_math', 'bottleneck_identification', 'operations'],
  ARRAY['warehouse pick-and-pack operations', 'airport security screening lanes', 'hospital patient intake and triage', 'factory assembly line production', 'call center ticket processing'],
  ARRAY['What is the maximum throughput this operation can support?', 'Which stage is constraining total system output?', 'How much daily contribution margin is being lost to the bottleneck?', 'Can current operations support the projected demand increase?'],
  '{"units_demanded_per_day": {"min": 800, "max": 5000, "step": 200, "unit": "units/day"}, "bottleneck_capacity": {"min": 600, "max": 4000, "step": 100, "unit": "units/day"}, "utilization_rate": {"min": 0.7, "max": 0.92, "step": 0.02, "unit": "%"}, "operating_hours_per_day": {"min": 8, "max": 24, "step": 4, "unit": "hours"}, "unit_contribution_margin": {"min": 15, "max": 120, "step": 5, "unit": "$"}}',
  ARRAY['Step 1: Calculate effective capacity = bottleneck_capacity × utilization_rate', 'Step 2: Calculate unmet demand = units_demanded_per_day - effective_capacity', 'Step 3: Calculate daily revenue lost = unmet_demand × unit_contribution_margin', 'Step 4: Determine if bottleneck relief (e.g. extra shift) covers the gap'],
  'The system output is always limited by the single slowest stage. Optimizing anything else first is waste.',
  ARRAY['Using total capacity instead of bottleneck capacity', 'Forgetting to apply utilization rate', 'Confusing units demanded with units producible'],
  'Find the constraint first. Everything upstream and downstream of it is irrelevant until it''s relieved.',
  ARRAY['operations', 'manufacturing', 'logistics', 'hospitals', 'airlines']
);