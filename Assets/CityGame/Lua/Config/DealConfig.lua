DealConfig={

    [1] = {
        name = "土地",--名字
        childs = {
            [1] = {
                name = "土地租凭",
                typeId = 888,
                EX=3
            },

            [2] = {
                name = "土地买卖",
                typeId= 999,
                EX=3
            },
        }
    },

    [2] = {
        name = "原料",--名字
        childs = {
            [1] ={
                name = "小麦",
                typeId= "2101001",
                EX=1
            },
            [2] ={
                name = "猪肉",
                typeId= "2101002",
                EX=1
            },
            [3] ={
                name = "鸡蛋",
                typeId= "2101003",
                EX=1
            },
            [4] ={
                name = "奶酪",
                typeId= "2101004",
                EX=1
            },
            [5] ={
                name = "棉",
                typeId= "2102001",
                EX=1
            },
            [6] ={
                name = "珊瑚绒",
                typeId= "2102002",
                EX=1
            },
            [7] ={
                name = "树胶",
                typeId= "2102003",
                EX=1
            },
            [8] ={
                name = "呢绒",
                typeId= "2102004",
                EX=1
            }


        }
    },
    [3] = {
        name = "商品", --名字
        childs = {
            [1] = {
                name = "主食",
                childs = {
                    [1] = {
                        name = "面包",
                        typeId = "2251101",
                         EX=2
                    },
                    [2] = {
                        name = "热狗",
                        typeId = "2251102",
                         EX=2
                    },
                    [3] = {
                        name = "蛋挞",
                        typeId = "2251103",
                         EX=2
                    },
                    [4] = {
                        name = "汉堡",
                        typeId = "2251201",
                         EX=2
                    },
                    [5] = {
                        name = "香肠",
                        typeId = "2251202",
                         EX=2
                    },
                    [6] = {
                        name = "三明治",
                        typeId = "2251203",
                         EX=2
                    },
                }
            },
            --[2] = {
            --    name = "副食",
            --    childs = {
            --        [1] = {
            --            name = "无",
            --            typeId = "000000",
            --             EX=2
            --        }
            --    }
            --},
            [2] = {
                name = "服饰",
                childs = {
                    [1] = {
                        name = "手套",
                        typeId = "2252101",
                         EX=2
                    },
                    [2] = {
                        name = "围巾",
                        typeId = "2252102",
                         EX=2
                    },
                    [3] = {
                        name = "冬帽",
                        typeId = "2252103",
                         EX=2
                    },
                    [4] = {
                        name = "西装",
                        typeId = "2252201",
                         EX=2
                    },
                    [5] = {
                        name = "毛衣",
                        typeId = "2252202",
                         EX=2
                    },
                    [6] = {
                        name = "大衣",
                        typeId = "2252203",
                         EX=2
                    },
                },
            },
            -- [4] = {
            --    name = "配饰",
            --    childs = {
            --        [1] = {
            --            name = "无",
            --            typeId = "0000000",
            --             EX=2
            --        }
            --    }
            --},
            --[5] = {
            --    name = "运动",
            --    childs = {
            --        [1] = {
            --            name = "无",
            --            typeId = "0000000",
            --             EX=2
            --        }
            --    }
            --},
            -- [6] = {
            --    name = "数码",
            --    childs = {
            --        [1] = {
            --            name = "无",
            --            typeId = "0000000",
            --             EX=2
            --        }
            --    }
            --},
        }
    },
        [4] = {
            name = "推广",--名字
            childs = {
                [1] = {
                    name = "建筑推广",
                    childs ={
                        [1] = {
                            name = "零售店",
                            typeId = 13,
                            EX=4
                        },
                        [2] = {
                            name = "住宅",
                            typeId= 14,
                            EX=4
                        },
                    }
                },
                [2] = {
                    name = "商品推广",
                    childs ={
                        [1] = {
                            name = "主食",
                            typeId = 51,
                            EX=4
                        },
                        --[2] = {
                        --    name = "副食",
                        --    typeId= 52,
                        --    EX=4
                        --},
                        [2] = {
                            name = "服装",
                            typeId= 53,
                            EX=4
                        },
                        --[4] = {
                        --    name = "配饰",
                        --    typeId= 54,
                        --    EX=4
                        --},
                        --[5] = {
                        --    name = "运动",
                        --    typeId= 55,
                        --    EX=4
                        --},
                        --[6] = {
                        --    name = "数码",
                        --    typeId= 56,
                        --    EX=4
                        --},
                    }
                }
            }
        },
        [5] = {
            name = "研究",--名字
            childs = {
                [1] = {
                    name = "发明",
                    typeId = 3,
                    EX=5
                },
                [2] = {
                    name = "EVA提升",
                    typeId= 4,
                    EX=5
                },
            }
        },
        --[6] = {
        --    name = "仓库租用", --名字
        --    childs = {
        --        [1] = {
        --            name = "无",
        --            typeId = 17,
        --            EX=6,
        --        },
        --    }
        --},
}
