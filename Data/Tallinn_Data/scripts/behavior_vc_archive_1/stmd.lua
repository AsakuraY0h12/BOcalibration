--[[
Model - Mode/destination choice for work-based tour
Type - logit
Authors - Siyu Li, Harish Loganathan, Olga Petrik
]]

-- all require statements do not work with C++. They need to be commented. The order in which lua files are loaded must be explicitly controlled in C++. 
--require "Logit"

--Estimated values for all betas
--Note: the betas that not estimated are fixed to zero.

--!! see the documentation on the definition of AM,PM and OP table!!

local beta_cost_bus_mrt_1 = -0.19
local beta_cost_Rail_SMS_1 = -0.19
local beta_cost_Rail_SMS_Pool_1 = -0.19
local beta_cost_private_bus_1 = -0.696
local beta_cost_drive1_1 = 0
local beta_cost_share2_1= 0
local beta_cost_share3_1= 0
local beta_cost_motor_1 = 0
local beta_cost_taxi_1 = 0
local beta_cost_SMS_1 = 0
local beta_cost_SMS_Pool_1 = 0

local beta_tt_bus_mrt = -3.78
local beta_tt_Rail_SMS = -3.78
local beta_tt_Rail_SMS_Pool = -3.78
local beta_tt_private_bus = 0
local beta_tt_drive1 = -4.64
local beta_tt_share2 = -5.45
local beta_tt_share3 = -3.53
local beta_tt_motor = 0
local beta_tt_walk = -0.675
local beta_tt_taxi = 0
local beta_tt_SMS = 0
local beta_tt_SMS_Pool = 0


local beta_log = 0.775
local beta_area = 0
local beta_population = 0 
local beta_employment = 0

local beta_central_bus_mrt = 0
local beta_central_Rail_SMS = 0
local beta_central_Rail_SMS_Pool = 0
local beta_central_private_bus = 0
local beta_central_drive1 = 0
local beta_central_share2 = 0
local beta_central_share3 = 0
local beta_central_motor = 0
local beta_central_walk = 0
local beta_central_taxi = 0
local beta_central_SMS = 0
local beta_central_SMS_Pool = 0

local beta_distance_bus_mrt = 0
local beta_distance_Rail_SMS = 0
local beta_distance_Rail_SMS_Pool = 0
local beta_distance_private_bus = 0 
local beta_distance_drive1 = 0
local beta_distance_share2 = 0
local beta_distance_share3 = 0
local beta_distance_motor = 0
local beta_distance_walk = 0
local beta_distance_taxi = 0
local beta_distance_SMS = 0
local beta_distance_SMS_Pool = 0

local beta_cons_bus = -2.892
local beta_cons_mrt = -3.358
local beta_cons_Rail_SMS = -9.768
local beta_cons_Rail_SMS_Pool = -20.335
local beta_cons_private_bus = -3.162
local beta_cons_drive1 = 0
local beta_cons_share2 = -4.294
local beta_cons_share3 = -5.575
local beta_cons_motor = -7.308
local beta_cons_walk = -7.924
local beta_cons_taxi = -9.075
local beta_cons_SMS = -8.575
local beta_cons_SMS_Pool = -12.168

local beta_female_bus = 0
local beta_female_mrt = 0
local beta_female_Rail_SMS = 0
local beta_female_Rail_SMS_Pool = 0
local beta_female_private_bus = 0
local beta_female_drive1 = 0
local beta_female_share2 = 0
local beta_female_share3 = 0
local beta_female_motor = 0
local beta_female_taxi = 0
local beta_female_SMS = 0
local beta_female_SMS_Pool = 0
local beta_female_walk = 0

local beta_mode_work_bus = 0
local beta_mode_work_mrt = 0
local beta_mode_work_Rail_SMS = 0
local beta_mode_work_Rail_SMS_Pool = 0
local beta_mode_work_private_bus = 0
local beta_mode_work_drive1 = 5.67
local beta_mode_work_share2 = 3.39
local beta_mode_work_share3 = 0
local beta_mode_work_motor = 0
local beta_mode_work_walk= 0

--choice set
local choice = {}
for i = 1, 616*10 do 
	choice[i] = i
end

--utility
-- 1 for public bus; 2 for MRT/LRT; 3 for private bus; 4 for drive1;
-- 5 for shared2; 6 for shared3+; 7 for motor; 8 for walk; 9 for taxi
local utility = {}
local function computeUtilities(params,dbparams)
	local female_dummy = params.female_dummy
	local mode_work_bus = dbparams.mode_to_work == 1 and 1 or 0
	local mode_work_mrt = dbparams.mode_to_work == 2 and 1 or 0
	local mode_work_Rail_SMS = dbparams.mode_to_work == 2 and 1 or 0
	local mode_work_Rail_SMS_Pool = dbparams.mode_to_work == 2 and 1 or 0
	local mode_work_private_bus = dbparams.mode_to_work == 3 and 1 or 0
	local mode_work_drive1 = dbparams.mode_to_work == 4 and 1 or 0
	local mode_work_share2 = dbparams.mode_to_work == 5 and 1 or 0
	local mode_work_share3 = dbparams.mode_to_work == 6 and 1 or 0
	local mode_work_motor = dbparams.mode_to_work == 7 and 1 or 0
	local mode_work_walk = dbparams.mode_to_work == 8 and 1 or 0

	local cost_bus = {}
	local cost_mrt = {}
	local cost_Rail_SMS = {}
	local cost_Rail_SMS_AE_1 = {}
	local cost_Rail_SMS_AE_2 = {}
	local cost_Rail_SMS_AE_avg = {}
	local cost_Rail_SMS_Pool = {}
	local cost_Rail_SMS_AE_Pool_1 = {}
	local cost_Rail_SMS_AE_Pool_2 = {}
	local cost_Rail_SMS_AE_Pool_avg = {}
	
	local cost_private_bus = {}
	local cost_drive1 = {}
	local cost_share2 = {}
	local cost_share3 = {}
	local cost_motor = {}
	local cost_taxi={}
	local cost_taxi_1 = {}
	local cost_taxi_2 = {}
	
	local cost_SMS={}
	local cost_SMS_1 = {}
	local cost_SMS_2 = {}
	local cost_SMS_Pool={}
	local cost_SMS_Pool_1 = {}
	local cost_SMS_Pool_2 = {}


	local central_dummy={}

	local tt_bus = {}
	local tt_mrt = {}
	local tt_Rail_SMS = {}
	local tt_Rail_SMS_Pool = {}
	local tt_private_bus = {}
	local tt_drive1 = {}
	local tt_share2 = {}
	local tt_share3 = {}
	local tt_motor = {}
	local tt_walk = {}
	local tt_taxi = {}
	local tt_SMS = {}
	local tt_SMS_Pool = {}
	local tt_car_ivt = {}
	local tt_public_ivt = {}
	local tt_public_out = {}

	local employment = {}
	local population = {}
	local area = {}
	local shop = {}

	local d1 = {}
	local d2 = {}
	

	
	--for each area
	for i =1,616 do
		d1[i] = dbparams:walk_distance1(i)
		d2[i] = dbparams:walk_distance2(i)
		
		cost_bus[i] = dbparams:cost_public_first(i) + dbparams:cost_public_second(i)
		cost_mrt[i] = cost_bus[i]
		
		cost_private_bus[i] = cost_bus[i]

		cost_drive1[i] = dbparams:cost_car_ERP_first(i)+dbparams:cost_car_ERP_second(i)+dbparams:cost_car_OP_first(i)+dbparams:cost_car_OP_second(i)+dbparams:cost_car_parking(i)
		cost_share2[i] = dbparams:cost_car_ERP_first(i)+dbparams:cost_car_ERP_second(i)+dbparams:cost_car_OP_first(i)+dbparams:cost_car_OP_second(i)+dbparams:cost_car_parking(i)/2
		cost_share3[i] = dbparams:cost_car_ERP_first(i)+dbparams:cost_car_ERP_second(i)+dbparams:cost_car_OP_first(i)+dbparams:cost_car_OP_second(i)+dbparams:cost_car_parking(i)/3
		cost_motor[i] = 0.5*(dbparams:cost_car_ERP_first(i)+dbparams:cost_car_ERP_second(i)+dbparams:cost_car_OP_first(i)+dbparams:cost_car_OP_second(i))+0.65*dbparams:cost_car_parking(i)
		
		central_dummy[i] = dbparams:central_dummy(i)
		

		cost_taxi_1[i] = 3.4+((d1[i]*(d1[i]>10 and 1 or 0)-10*(d1[i]>10 and 1 or 0))/0.35+(d1[i]*(d1[i]<=10 and 1 or 0)+10*(d1[i]>10 and 1 or 0))/0.4)*0.22+ dbparams:cost_car_ERP_first(i) + central_dummy[i]*3
		cost_taxi_2[i] = 3.4+((d2[i]*(d2[i]>10 and 1 or 0)-10*(d2[i]>10 and 1 or 0))/0.35+(d2[i]*(d2[i]<=10 and 1 or 0)+10*(d2[i]>10 and 1 or 0))/0.4)*0.22+ dbparams:cost_car_ERP_second(i) + central_dummy[i]*3
		cost_taxi[i] = cost_taxi_1[i] + cost_taxi_2[i]
		
		cost_SMS_1[i] = 3.4+((d1[i]*(d1[i]>10 and 1 or 0)-10*(d1[i]>10 and 1 or 0))/0.35+(d1[i]*(d1[i]<=10 and 1 or 0)+10*(d1[i]>10 and 1 or 0))/0.4)*0.22+ dbparams:cost_car_ERP_first(i) + central_dummy[i]*3
		cost_SMS_2[i] = 3.4+((d2[i]*(d2[i]>10 and 1 or 0)-10*(d2[i]>10 and 1 or 0))/0.35+(d2[i]*(d2[i]<=10 and 1 or 0)+10*(d2[i]>10 and 1 or 0))/0.4)*0.22+ dbparams:cost_car_ERP_second(i) + central_dummy[i]*3
		cost_SMS[i] = (cost_SMS_1[i] + cost_SMS_2[i])*0.72
		
		cost_SMS_Pool_1[i] = 3.4+((d1[i]*(d1[i]>10 and 1 or 0)-10*(d1[i]>10 and 1 or 0))/0.35+(d1[i]*(d1[i]<=10 and 1 or 0)+10*(d1[i]>10 and 1 or 0))/0.4)*0.22+ dbparams:cost_car_ERP_first(i) + central_dummy[i]*3
		cost_SMS_Pool_2[i] = 3.4+((d2[i]*(d2[i]>10 and 1 or 0)-10*(d2[i]>10 and 1 or 0))/0.35+(d2[i]*(d2[i]<=10 and 1 or 0)+10*(d2[i]>10 and 1 or 0))/0.4)*0.22+ dbparams:cost_car_ERP_second(i) + central_dummy[i]*3
		cost_SMS_Pool[i] = (cost_SMS_Pool_1[i] + cost_SMS_Pool_2[i])*0.72*0.7
		
		local aed = 2.0 -- Access egress distance
		cost_Rail_SMS_AE_1[i] = 3.4+((aed*(aed>10 and 1 or 0)-10*(aed>10 and 1 or 0))/0.35+(aed*(aed<=10 and 1 or 0)+10*(aed>10 and 1 or 0))/0.4)*0.22+ dbparams:cost_car_ERP_first(i) + central_dummy[i]*3
		cost_Rail_SMS_AE_2[i] = 3.4+((aed*(aed>10 and 1 or 0)-10*(aed>10 and 1 or 0))/0.35+(aed*(aed<=10 and 1 or 0)+10*(aed>10 and 1 or 0))/0.4)*0.22+ dbparams:cost_car_ERP_second(i) + central_dummy[i]*3
		cost_Rail_SMS_AE_avg[i] = (cost_Rail_SMS_AE_1[i] + cost_Rail_SMS_AE_2[i])/2

		cost_Rail_SMS[i] = cost_mrt[i] + cost_Rail_SMS_AE_avg[i]*0.72
		
		cost_Rail_SMS_AE_Pool_1[i] = 3.4+((aed*(aed>10 and 1 or 0)-10*(aed>10 and 1 or 0))/0.35+(aed*(aed<=10 and 1 or 0)+10*(aed>10 and 1 or 0))/0.4)*0.22+ dbparams:cost_car_ERP_first(i) + central_dummy[i]*3
		cost_Rail_SMS_AE_Pool_2[i] = 3.4+((aed*(aed>10 and 1 or 0)-10*(aed>10 and 1 or 0))/0.35+(aed*(aed<=10 and 1 or 0)+10*(aed>10 and 1 or 0))/0.4)*0.22+ dbparams:cost_car_ERP_second(i) + central_dummy[i]*3
		cost_Rail_SMS_AE_Pool_avg[i] = (cost_Rail_SMS_AE_Pool_1[i] + cost_Rail_SMS_AE_Pool_2[i])/2

		cost_Rail_SMS_Pool[i] = cost_mrt[i] + cost_Rail_SMS_AE_Pool_avg[i]*0.72*0.7

		tt_car_ivt[i] = dbparams:tt_car_ivt_first(i) + dbparams:tt_car_ivt_second(i)
		tt_public_ivt[i] = dbparams:tt_public_ivt_first(i) + dbparams:tt_public_ivt_second(i)
		tt_public_out[i] = dbparams:tt_public_out_first(i) + dbparams:tt_public_out_second(i)

		tt_bus[i] = tt_public_ivt[i]+ tt_public_out[i]
		tt_mrt[i] = tt_public_ivt[i]+ tt_public_out[i]
		tt_Rail_SMS[i] = tt_public_ivt[i]+ tt_public_out[i]/6.0
		tt_Rail_SMS_Pool[i] = tt_public_ivt[i]+ tt_public_out[i]/6.0+(aed+aed)/60+1/10
		tt_private_bus[i] = tt_car_ivt[i]
		tt_drive1[i] = tt_car_ivt[i] + 1.0/6
		tt_share2[i] = tt_car_ivt[i] + 1.0/6
		tt_share3[i] = tt_car_ivt[i] + 1.0/6
		tt_motor[i] = tt_car_ivt[i] + 1.0/6
		tt_walk[i] = (d1[i]+d2[i])/5
		tt_taxi[i] = tt_car_ivt[i] + 1.0/6
		tt_SMS[i] = tt_car_ivt[i] + 1.0/6
		tt_SMS_Pool[i] = tt_car_ivt[i] + 1.0/6+ 1/10+(d1[i]+d2[i])/2/60 + 1.0/6

		employment[i] = dbparams:employment(i)
		population[i] = dbparams:population(i)
		area[i] = dbparams:area(i)
		shop[i] = dbparams:shop(i)
	end

	local exp = math.exp
	local log = math.log

	local V_counter = 0

	--utility function for bus 1-24
	for i =1,616 do
		V_counter = V_counter + 1
		utility[V_counter] = beta_cons_bus + cost_bus[i] * beta_cost_bus_mrt_1 + tt_bus[i] * beta_tt_bus_mrt + beta_central_bus_mrt * central_dummy[i] + beta_log * log(shop[i]+exp(beta_employment)*employment[i]) + (d1[i]+d2[i]) * beta_distance_bus_mrt + beta_female_bus * female_dummy + beta_mode_work_bus * mode_work_bus
	end

	--utility function for mrt 1-24
	for i=1,616 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_mrt + cost_mrt[i] * beta_cost_bus_mrt_1 + tt_mrt[i] * beta_tt_bus_mrt + beta_central_bus_mrt * central_dummy[i] + beta_log * log(shop[i]+exp(beta_employment)*employment[i]) + (d1[i]+d2[i]) * beta_distance_bus_mrt + beta_female_mrt * female_dummy + beta_mode_work_bus * mode_work_mrt
	end

	--utility function for private bus 1-24
	for i=1,616 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_private_bus + cost_private_bus[i] * beta_cost_private_bus_1 + tt_private_bus[i] * beta_tt_bus_mrt + beta_central_private_bus * central_dummy[i] + beta_log * log(shop[i]+exp(beta_employment)*employment[i]) + (d1[i]+d2[i]) * beta_distance_private_bus + beta_female_private_bus * female_dummy + beta_mode_work_bus * mode_work_private_bus
	end

	--utility function for drive1 1-24
	for i=1,616 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_drive1 + cost_drive1[i] * beta_cost_drive1_1 + tt_drive1[i] * beta_tt_drive1 + beta_central_drive1 * central_dummy[i] + beta_log * log(shop[i]+exp(beta_employment)*employment[i]) + (d1[i]+d2[i]) * beta_distance_drive1 + beta_female_drive1 * female_dummy + beta_mode_work_drive1 * mode_work_drive1 
	end

	--utility function for share2 1-24
	for i=1,616 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_share2 + cost_share2[i] *beta_cost_drive1_1 + tt_share2[i] * beta_tt_share2 + beta_central_share2 * central_dummy[i] + beta_log * log(shop[i]+exp(beta_employment)*employment[i]) + (d1[i]+d2[i]) * beta_distance_share2 + beta_female_share2 * female_dummy + beta_mode_work_share2 * mode_work_share2
	end

	--utility function for share3 1-24
	for i=1,616 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_share3 + cost_share3[i] * beta_cost_drive1_1 + tt_share3[i] * beta_tt_share3 + beta_central_share3 * central_dummy[i] + beta_log * log(shop[i]+exp(beta_employment)*employment[i]) + (d1[i]+d2[i]) * beta_distance_share3 + beta_female_share3 * female_dummy + beta_mode_work_share2 * mode_work_share3
	end

	--utility function for motor 1-24
	for i=1,616 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_motor + cost_motor[i] * beta_cost_drive1_1 + tt_motor[i] * beta_tt_motor + beta_central_motor * central_dummy[i] + beta_log * log(shop[i]+exp(beta_employment)*employment[i]) + (d1[i]+d2[i]) * beta_distance_motor + beta_female_motor * female_dummy + beta_mode_work_drive1 * mode_work_motor
	end

	--utility function for walk 1-24
	for i=1,616 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_walk + tt_walk[i] * beta_tt_walk + beta_central_walk * central_dummy[i] + beta_log * log(shop[i]+exp(beta_employment)*employment[i]) + (d1[i]+d2[i]) * beta_distance_walk + beta_female_walk * female_dummy + beta_mode_work_walk * mode_work_walk
	end

	--utility function for taxi 1-24
	for i=1,616 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_taxi + cost_taxi[i] * beta_cost_drive1_1 + tt_taxi[i] * beta_tt_taxi + beta_central_taxi * central_dummy[i] + beta_log * log(shop[i]+exp(beta_employment)*employment[i]) + (d1[i]+d2[i]) * beta_distance_taxi + beta_female_taxi * female_dummy
	end
	
	--utility function for SMS 1-24
	for i=1,616 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_SMS + cost_SMS[i] * beta_cost_drive1_1 + tt_SMS[i] * beta_tt_SMS + beta_central_SMS * central_dummy[i] + beta_log * log(shop[i]+exp(beta_employment)*employment[i]) + (d1[i]+d2[i]) * beta_distance_SMS + beta_female_SMS * female_dummy
	end
	
	--utility function for Rail_SMS 1-24
	--for i=1,24 do
	--	V_counter = V_counter +1
	--	utility[V_counter] = beta_cons_Rail_SMS + cost_Rail_SMS[i] * beta_cost_Rail_SMS_1 + tt_Rail_SMS[i] * beta_tt_Rail_SMS + beta_central_Rail_SMS * central_dummy[i] + beta_log * log(shop[i]+exp(beta_employment)*employment[i]) + (d1[i]+d2[i]) * beta_distance_Rail_SMS + beta_female_Rail_SMS * female_dummy + beta_mode_work_bus * mode_work_Rail_SMS
	--end
		
	--utility function for SMS_Pool 1-24
	--for i=1,24 do
	--	V_counter = V_counter +1
	--	utility[V_counter] = beta_cons_SMS_Pool + cost_SMS_Pool[i] * beta_cost_drive1_1 + tt_SMS_Pool[i] * beta_tt_SMS_Pool + beta_central_SMS_Pool * central_dummy[i] + beta_log * log(shop[i]+exp(beta_employment)*employment[i]) + (d1[i]+d2[i]) * beta_distance_SMS_Pool + beta_female_SMS_Pool * female_dummy
	--end
	
	--utility function for Rail_SMS_Pool 1-24
	--for i=1,24 do
	--	V_counter = V_counter +1
	--	utility[V_counter] = beta_cons_Rail_SMS_Pool + cost_Rail_SMS_Pool[i] * beta_cost_Rail_SMS_Pool_1 + tt_Rail_SMS_Pool[i] * beta_tt_Rail_SMS_Pool + beta_central_Rail_SMS_Pool * central_dummy[i] + beta_log * log(shop[i]+exp(beta_employment)*employment[i]) + (d1[i]+d2[i]) * beta_distance_Rail_SMS_Pool + beta_female_Rail_SMS_Pool * female_dummy + beta_mode_work_bus * mode_work_Rail_SMS_Pool
	--end
end


--availability
--the logic to determine availability is the same with current implementation
local availability = {}
local function computeAvailabilities(params,dbparams)
	for i = 1, 616*10 do 
		availability[i] = dbparams:availability(i)
	end
end

--scale
local scale = 1 -- for all choices

function choose_stmd(params,dbparams)
	computeUtilities(params,dbparams) 
	computeAvailabilities(params,dbparams)
	local probability = calculate_probability("mnl", choice, utility, availability, scale)
	return make_final_choice(probability)
end
