DealConfig={
    [1] = {
        name = "基本信息",--名字
        typeId= "2101001",
        EX=1
    },

    [2] = {
        name = "NPC供应",
        childs = {
            [1] ={
                name = "原料",
                childs = {
                    [1] = { name = "服饰原料",
                            typeId= "2101001",
                            EX=2
                    },
                    [2] = { name = "食品原料",
                            typeId= "2101001",
                            EX=2
                    }
                }
            },
            [2] = {
                name = "商品 ",
                childs = {
                    [1] = {
                        name = "服饰",
                        typeId= "2101001",
                        EX=2
                    },
                    [2] = {
                        name = "食品",
                        typeId= "2101001",
                        EX=2
                    }
                }
            },
            [3] = {
                name = "住宅",
                typeId= "2101001",
                EX=2
            },
        }
    },
    [3] = {
        name = "原料厂",--名字
        childs = {
            [1] ={
                name = "小麦",
                typeId= "2101001",
                EX=3
            },
            [2] ={
                name = "猪肉",
                typeId= "2101002",
                EX=3
            },
            [3] ={
                name = "鸡蛋",
                typeId= "2101003",
                EX=3
            },
            [4] ={
                name = "奶酪",
                typeId= "2101004",
                EX=3
            },
            [5] ={
                name = "棉",
                typeId= "2102001",
                EX=3
            },
            [6] ={
                name = "棉",
                typeId= "2102001",
                EX=3
            },
            [7] ={
                name = "珊瑚绒",
                typeId= "2102002",
                EX=3
            },
            [8] ={
                name = "树胶",
                typeId= "2102003",
                EX=3
            },
            [9] ={
                name = "呢绒",
                typeId= "2102004",
                EX=3
            },
        }
    },

    [4] = {
        name = "加工厂",--名字
        childs = {
            [1] ={
                name = "面包",
                typeId= "2251101",
                EX=4
            },
            [2] ={
                name = "热狗",
                typeId= "2251102",
                EX=4
            },
            [3] ={
                name = "蛋挞",
                typeId= "2251103",
                EX=4
            },
            [4] ={
                name = "汉堡",
                typeId= "2251201",
                EX=4
            },
            [5] ={
                name = "香肠",
                typeId= "2251202",
                EX=4
            },
            [6] ={
                name = "三明治",
                typeId= "2251203",
                EX=4
            },
            [7] ={
                name = "手套",
                typeId= "2252101",
                EX=4
            },
            [8] ={
                name = "围巾",
                typeId= "2252102",
                EX=4
            },
            [9] ={
                name = "冬帽",
                typeId= "2252103",
                EX=4
            },
            [10] ={
                name = "西装",
                typeId= "2252201",
                EX=4
            },
            [11] ={
                name = "毛衣",
                typeId= "2252202",
                EX=4
            },
            [12] ={
                name = "大衣",
                typeId= "2252203",
                EX=4
            },
        }
    },

    [5] = {
        name = "零售店",--名字
        childs = {
            [1] = {
                name = "食品",
                childs = {
                    [1] = {
                        name = "面包",
                        typeId = 10,
                        EX = 5,
                    },
                    [2] = {
                        name = "汉堡",
                        typeId = 11,
                        EX = 5,
                    },
                    [3] = {
                        name = "冰淇淋",
                        typeId = 12,
                        EX = 5,
                    },
                    [4] = {
                        name = "西装",
                        typeId = 13,
                        EX = 5,
                    },

                }
            }
        }
    },
    [6] = {
        name = "住宅",--名字
        typeId = 13,
        EX=6
    },
        [7] = {
            name = "广告",--名字
            childs = {
                [1] = {
                    name = "食品推广",
                    typeId = 13,
                    EX=7
                        },
                [2] = {
                    name = "服饰推广",
                    typeId= 14,
                    EX=7
                },
                [3] = {
                    name = "化妆品推广",
                    typeId= 15,
                    EX=7
                },
                [4] = {
                    name = "零售店推广",
                    typeId= 16,
                    EX=7
                },
                [5] = {
                    name = "住宅推广",
                    typeId= 17,
                    EX=7
                },
            }
        },
        [8] = {
            name = "研究",--名字
            childs = {
                [1] = {
                    name = "新商品发明",
                    typeId = 3,
                    EX=8
                },
                [2] = {
                    name = "EVA点数研究",
                    typeId= 4,
                    EX=8
                },
            }
        },

    [9] = {
        name = "土地",--名字
        childs = {
            [1] = {
                name = "土地拍卖",
                typeId = 888,
                EX=9
            },

            [2] = {
                name = "土地出售",
                typeId= 999,
                EX=9
            },
            [3] = {
                name = "土地租赁",
                typeId= 1110,
                EX=9
            },
        }
    },
}
