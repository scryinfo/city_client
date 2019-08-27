CityInfoConfig = {
	[1] ={
		name = '行业销售额',
	},
	[2] ={
		name = '原料厂',
		content = {
			[1] = {
				name = '行业供需',	
				type = 11,
				id = 1,
			},
			[2] = {
				name = '收入排行',
				type = 11,
				id = 2,
			},
			[3] = {
				name = '行业详细数据',
				type = 11,
				id = 3,
				 inside={
					[1] ={
						name =2101001,
						itemId = 2101001,
						date = {
							[1] ={
							name ="销售额",
							id = 1,
							},
							[2] ={
							name ="供需",
							id = 2,
							},
							[3] ={
							name ="成交均价",
							id = 3,
							},
							[4] ={
							name ="玩家排行",
							id = 4,
							},
							[5] ={
							name ="EVA等级分布",
							id = 5,
							},
						},
					},
				},
			},
		}
	},
	[3] ={
		name = '加工厂',
		content = {
			[1] = {
				name = '行业供需',
				type = 12,
				id = 1,
			},
			[2] = {
				name = '收入排行',
				type = 12,
				id = 2,
			},
			[3] = {
				name = '行业详细数据',
				type = 12,
				id = 3,
				 inside={
					[1] ={
						name =2251101,
						itemId = 2251101,
						date = {
							[1] ={
							name ="销售额",
							id = 1,
							},
							[2] ={
							name ="供需",
							id = 2,
							},
							[3] ={
							name ="成交均价",
							id = 3,
							},
							[4] ={
							name ="玩家排行",
							id = 4,
							},
							[5] ={
							name ="EVA等级分布",
							id = 5,
							},
						},
					},

				},
			},
		},
	},
	[4] ={
		name = '零售店',	
		content = {
			[1] = {
				name = '行业供需',
				type = 13,
				id = 1,
			},
			[2] = {
				name = '收入排行',
				type = 13,
				id = 2,
			},
			[3] = {
				name = '建筑EVA等级分布',
				type = 13,
				id = 4,
			},
			[4] = {
				name = '行业详细数据',
				type = 13,
				id = 3,
				 inside={
					[1] ={
						name =2251101,
						itemId = 2251101,
						date = {
							[1] ={
							name ="销售额",
							id = 1,
							},
							[2] ={
							name ="供需",
							id = 2,
							},
							[3] ={
							name ="成交均价",
							id = 3,
							},
							[4] ={
							name ="玩家排行",
							id = 4,
							},
						},
					},
				},
			},
		},
	},
	[5] ={
		name = '住宅',
		content = {
			[1] = {
				name = '行业供需',
				type = 14,
				id = 1,
			},
			[2] = {
				name ='成交均价',
				type = 14,
				id = 5,
			},
			[3] = {
				name = '收入排行',
				type = 14,
				id = 2,
			},
			[4] = {
				name ='EVA等级分布',
				type = 14,
				id = 4,
		    },
		},
	},
	[6] ={
		name = '数据公司',
		content = {
			[1] = {
				name = '行业供需',
				type = 16,
				id = 1,
			},
			[2] = {
				name = '收入排行',
				type = 16,
				id = 2,
			},
			[3] = {
				name = '行业详细数据',
				type = 16,
				id = 3,
				inside = {
					[1] = {
						name = '加工厂数据资料',
						itemId = 1600012,
						date = {
							[1] = {
								name ='销售额',
								id = 1,
							},
							[2] = {
								name ='供需',
								id = 2,
							},
							[3] = {
								name ='成交均价',
								id = 3,
							},
							[4] = {
								name ='玩家排行',
								id = 4,
							},
							[5] = {
								name ='EVA等级分布',
								id = 5,
							},
						},
					},
					[2] = {
						name = '零售店数据资料',
						itemId = 1600013,
						date = {
							[1] = {
								name ='销售额',
								id = 1,
							},
							[2] = {
								name ='供需',
								id = 2,
							},
							[3] = {
								name ='成交均价',
								id = 3,
							},
							[4] = {
								name ='玩家排行',
								id = 4,
							},
							[5] = {
								name ='EVA等级分布',
								id = 5,
							},
						},
					},
					[3] = {
						name = '住宅数据资料',
						itemId = 1600014,
						date = {
							[1] = {
								name ='销售额',
								id = 1,
							},
							[2] = {
								name ='供需',
								id = 2,
							},
							[3] = {
								name ='成交均价',
								id = 3,
							},
							[4] = {
								name ='玩家排行',
								id = 4,
							},
							[5] = {
								name ='EVA等级分布',
								id = 5,
							},
						},
					},
				},
			},
		},
	},
	[7] ={
		name = '研究所',
		content = {
			[1] = {
				name = '行业供需',
				type = 15,
				id = 1,
			},
			[2] = {
				name = '收入排行',
				type = 15,
				id = 2,
			},
			[3] = {
				name = '行业详细数据',
				type = 15,
				id = 3,
				inside = {
					[1] = {
						name = 'EVA原料厂',
						itemId = 1500011,
						date = {
							[1] = {
								name ='销售额',
								id = 1,
							},
							[2] = {
								name ='供需',
								id = 2,
							},
							[3] = {
								name ='成交均价',
								id = 3,
							},
							[4] = {
								name ='玩家排行',
								id = 4,
							},
							[5] = {
								name ='EVA等级分布',
								id = 5,
							},
						},
					},
					[2] = {
						name = 'EVA加工厂',
						itemId = 1500012,
						date = {
							[1] = {
								name ='销售额',
								id = 1,
							},
							[2] = {
								name ='供需',
								id = 2,
							},
							[3] = {
								name ='成交均价',
								id = 3,
							},
							[4] = {
								name ='玩家排行',
								id = 4,
							},
							[5] = {
								name ='EVA等级分布',
								id = 5,
							},
						},
					},
					[3] = {
						name = 'EVA零售店',
						itemId = 1500013,
						date = {
							[1] = {
								name ='销售额',
								id = 1,
							},
							[2] = {
								name ='供需',
								id = 2,
							},
							[3] = {
								name ='成交均价',
								id = 3,
							},
							[4] = {
								name ='玩家排行',
								id = 4,
							},
							[5] = {
								name ='EVA等级分布',
								id = 5,
							},
						},
					},
					[4] = {
						name = 'EVA住宅',
						itemId = 1500014,
						date = {
							[1] = {
								name ='销售额',
								id = 1,
							},
							[2] = {
								name ='供需',
								id = 2,
							},
							[3] = {
								name ='成交均价',
								id = 3,
							},
							[4] = {
								name ='玩家排行',
								id = 4,
							},
							[5] = {
								name ='EVA等级分布',
								id = 5,
							},
						},
					},
					[5] = {
						name = 'EVA数据公司',
						itemId = 1500016,
						date = {
							[1] = {
								name ='销售额',
								id = 1,
							},
							[2] = {
								name ='供需',
								id = 2,
							},
							[3] = {
								name ='成交均价',
								id = 3,
							},
							[4] = {
								name ='玩家排行',
								id = 4,
							},
							[5] = {
								name ='EVA等级分布',
								id = 5,
							},
						},
					},
					[6] = {
						name = 'EVA研究所',
						itemId = 1500015,
						date = {
							[1] = {
								name ='销售额',
								id = 1,
							},
							[2] = {
								name ='供需',
								id = 2,
							},
							[3] = {
								name ='成交均价',
								id = 3,
							},
							[4] = {
								name ='玩家排行',
								id = 4,
							},
							[5] = {
								name ='EVA等级分布',
								id = 5,
							},
						},
					},
				},
			},
		},
	},
	[8] ={
		name = '土地交易',
		content = {
			[1] = {
				name = '行业供需',
				type = 20,
				id = 1,
			},
			[2] = {
				name ='成交均价',id = 3,
				type = 20,
				id = 5,
			},
			[3] = {
				name = '收入排行',
				type = 20,
				id = 2,
			},
		},
	}
}
