Config = {}


Config.lawmenMinimun = 0

Config.PoliceChance = 20
Config.npcChance = 100
Config.HouseCooldowns = 1800 -- In Seconds 
Config.DeletePropAfterInteraction = true -- if true, Props will be removed once you interact with them // if false props only get removed once you leave the house

Config.SearchingTime = 3000
Config.BreakInItem = 'lockpick'
Config.LockpickBreaksOnError = true -- on Break In if lockpick minigame is failed lockpick gets broken

Config.Animations = {
	HouseEnter = {
		anim = 'script_ca@carust@02@ig@ig1_rustlerslockpickingconv01',
		clip = 'idle_04_smhthug_01',
	}
}

Config.HousesToRob =  {
	[1] = { 
		name = "house1",
		entercoords = vec4(-929.45, -1271.96, 51.44, 162.72),
		houseInformation = { -- tier 1 house
			exit = vec3(-691.928, 1042.7164, 123.98477),
			locations = {
				[2] = { prop = 'p_cabinet03x' ,coords = vec4(-688.49, 1045.67, 124.99, 297.45),rot = vec3(0,0,0),  rewards = { "hair_razor","harmonica"},rewardsAmount = {min = 1, max = 3},},
				[3] = { prop = 'p_sofa01x' ,coords = vec4(-687.68, 1041.37, 124.99, 215.67), rot = vec3(0,0,0), rewards = { "bread","lockpick"},rewardsAmount = {min = 1, max = 3},},
			},
			Dog = { chance = 0 , model = 'a_c_doghound_01' ,coords = vec4(-690.10, 1046.70, 124.98, 164.13)},
			SpecialProp = { chance = 0 , prop = 'p_cs_footlocker01x' ,coords = vec4(2822.94, 270.74, 35.50, 213.09), rewards = {"weapon_bow"},rewardsAmount = {min = 1, max = 1}, },
			npcModel = 'msp_reverend1_males_01',
			npcSpawnLocation = vec3(-689.13, 1044.29, 124.99),
			npcWeapon = "WEAPON_UNARMED",
			ammoCount = 50,
		}
	},
	[2] = {
		name = "house2",
		entercoords = vec4(2594.74, -1113.96, 52.88, 359.73),
		houseInformation = { -- Tier 2 house
			exit = vec3(223.31, 990.19, 179.88),
			locations = {
				[1] = { prop = 'p_vase01x' ,coords = vec4(222.60, 983.50, 180.88, 200.58),rot = vec3(0,0,0), rewards = { "earring_gold","golden_ring"},rewardsAmount = {min = 1, max = 3},},
				[2] = { prop = 'p_cabinet03x' ,coords = vec4(216.29, 985.56, 180.88, 83.49), rot = vec3(0,0,0),rewards = { "harmonica","golden_ring"},rewardsAmount = {min = 1, max = 3},},
				[3] = { prop = 'p_sofa01x' ,coords = vec4(219.06, 984.11, 180.88, 192.93),rot = vec3(0,0,0),  rewards = { "earring_pearl","earring_gold"},rewardsAmount = {min = 1, max = 3},},
			},
			Dog = { chance = 10 , model = 'a_c_doghound_01' ,coords = vec4(224.33, 985.10, 180.89, 20.62)},
			SpecialProp = { chance = 0 , prop = 'p_cs_footlocker01x' ,coords = vec4(2822.94, 270.74, 35.50, 213.09), rewards = {"weapon_bow"},rewardsAmount = {min = 1, max = 3}, },
			npcModel = 'msp_reverend1_males_01',
			npcSpawnLocation = vec3(217.45, 986.90, 180.88),
			npcWeapon = "WEAPON_REVOLVER_CATTLEMAN",
			ammoCount = 50,
		},
	},
	[3] = {
		name = "house3",
		entercoords = vec4(2642.89, -1072.41, 49.33, 89.97),
		houseInformation = { -- Tier 3 house
			exit = vec3(2820.5056, 278.17382, 34.49282),
			locations = {
				[1] = { prop = 'p_vase01x' ,coords = vec4(2818.39, 275.73, 35.50, 230.85), rot = vec3(0,0,0),rewards = { "golden_ring","ring_thorburn_turquoise"},rewardsAmount = {min = 1, max = 3},},
				[2] = { prop = 'p_cabinet03x' ,coords = vec4(2816.13, 273.00, 35.50, 47.71), rot = vec3(0,0,0),rewards = { "golden_ring","jewelry_box"},rewardsAmount = {min = 1, max = 3},},
				[3] = { prop = 'p_sofa01x' ,coords = vec4(2827.01, 275.18, 35.50, 225.24), rot = vec3(0,0,0),rewards = { "earring_orchidee_diamond","jewelry_box"},rewardsAmount = {min = 1, max = 3},},
			},
			Dog = { chance = 100 , model = 'a_c_doghound_01' ,coords = vec4(2823.83, 274.86, 35.49, 37.39)},
			SpecialProp = { chance = 10, prop = 'p_cs_footlocker01x' ,coords = vec4(2822.94, 270.74, 35.50, 213.09), rewards = {"WEAPON_REVOLVER_CATTLEMAN"},rewardsAmount = {min = 1, max = 3}, },
			npcModel = 'msp_reverend1_males_01',
			npcSpawnLocation = vec3(2816.45, 271.24, 35.49),
			npcWeapon = "weapon_shotgun_doublebarrel",
			ammoCount = 50,
		},
	},			
}