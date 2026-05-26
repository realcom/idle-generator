{
  "blocks": {
    "blocks": [
      {
        "id": "RVP*E|?|PgD[Tw@nP%Ed",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "TYPE": "board",
                "VAR": {
                  "id": ";!/+GYBZd;P?1n6,vrn|"
                }
              },
              "id": "VV09,:;-EPXz.uJ!f+(]",
              "inputs": {
                "VALUE": {
                  "block": {
                    "fields": {
                      "BOOL": "TRUE"
                    },
                    "id": "KJ38Rwg*SRut*._ztYL}",
                    "type": "logic_boolean"
                  }
                }
              },
              "next": {
                "block": {
                  "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;name&quot;:&quot;BoardState&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "boardMethod:SetBoardState",
                    "THIS": true
                  },
                  "id": "S45+@iXtti-hxIxR6_??",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "fields": {
                          "VAR": "1001"
                        },
                        "id": "-^%jBjF9gQOor:R2qx)I",
                        "type": "gameboardstates_get"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                      "fields": {
                        "NAME": "boardMethod:AddUnit",
                        "THIS": true
                      },
                      "id": "Pg;IH2t5^T6|}A:upU(7",
                      "inputs": {
                        "ARG0": {
                          "block": {
                            "extraState": "<mutation></mutation>",
                            "fields": {
                              "TYPE": "board",
                              "VAR": {
                                "id": "RwiY5f@ILEq-nK4Our9Q"
                              }
                            },
                            "id": "*s@U}Q_VZmuDo}}`0}bo",
                            "type": "variables_get"
                          }
                        },
                        "ARG2": {
                          "block": {
                            "fields": {
                              "NUM": 9
                            },
                            "id": "!DfG5Vtu{Rft4{f]!0wo",
                            "type": "math_number"
                          }
                        },
                        "ARG4": {
                          "block": {
                            "fields": {
                              "NUM": 0
                            },
                            "id": "NJ5xuhd#Dg!XJsx-|x_w",
                            "type": "math_number"
                          }
                        },
                        "ARG5": {
                          "block": {
                            "fields": {
                              "VAR": "Neutral"
                            },
                            "id": "a3/REdC:o]VHpm7ToV@N",
                            "type": "teamtag_get"
                          }
                        },
                        "ARG6": {
                          "block": {
                            "fields": {
                              "NUM": 1
                            },
                            "id": "q,MkOJGVsn%{kh$Q]ZaA",
                            "type": "math_number"
                          }
                        }
                      },
                      "next": {
                        "block": {
                          "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                          "fields": {
                            "NAME": "boardMethod:BlockMoveAction",
                            "THIS": false
                          },
                          "id": "hNy}mj%?u{2_7lwe/SB@",
                          "type": "function_call"
                        }
                      },
                      "type": "function_call"
                    }
                  },
                  "type": "function_call"
                }
              },
              "type": "variables_set"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "AND"
              },
              "id": "wDo!2Rhd2-Wuv1rp71Tl",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "KFkM*32U1y+8P8OALs12",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": ";!/+GYBZd;P?1n6,vrn|"
                            }
                          },
                          "id": "|DqU0,Tp=LRMjuiqxKiT",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "BOOL": "FALSE"
                          },
                          "id": "_NAp9p~K@:+7ox??:sqA",
                          "type": "logic_boolean"
                        }
                      }
                    },
                    "type": "logic_compare"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "xQlY6vq+A)$+`t.z`(=4",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "N50$#3}.qT#=XYSh{#{Z"
                            }
                          },
                          "id": "^QytD#x}L~_DY3Hf50)@",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "BOOL": "FALSE"
                          },
                          "id": "H{4^^Ler9^)bL4rwl8@(",
                          "type": "logic_boolean"
                        }
                      }
                    },
                    "type": "logic_compare"
                  }
                }
              },
              "type": "logic_operation"
            }
          }
        },
        "type": "controls_if",
        "x": 645,
        "y": -795
      },
      {
        "id": "q~|IVu!2W_xelIjUOpTR",
        "inputs": {
          "DO0": {
            "block": {
              "id": "k=ykn[b!+gKaT*i,o(I~",
              "inputs": {
                "DO0": {
                  "block": {
                    "fields": {
                      "NAME": "Log"
                    },
                    "id": "_YC4F^p=z9FGnEBrOr@.",
                    "inputs": {
                      "TEXT": {
                        "block": {
                          "fields": {
                            "TEXT": "Battle ends"
                          },
                          "id": "9dH2td[#G6e`8%^{*B79",
                          "type": "text"
                        }
                      }
                    },
                    "next": {
                      "block": {
                        "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Team (필수)&quot;,&quot;name&quot;:&quot;Team&quot;}]\"></mutation>",
                        "fields": {
                          "NAME": "boardMethod:KillAllUnits",
                          "THIS": false
                        },
                        "id": "E#0J1QY@2lIQwMt6Y3Vm",
                        "inputs": {
                          "ARG0": {
                            "block": {
                              "fields": {
                                "VAR": "Enemy"
                              },
                              "id": "fgMQ!Y8JBRB#|r+UG#);",
                              "type": "teamtag_get"
                            }
                          }
                        },
                        "next": {
                          "block": {
                            "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Winning team (필수)&quot;,&quot;name&quot;:&quot;Team&quot;}]\"></mutation>",
                            "fields": {
                              "NAME": "boardMethod:EndGame",
                              "THIS": false
                            },
                            "id": "0o?XR-h4rQ]hs/SP:j@;",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "fields": {
                                    "VAR": "Player"
                                  },
                                  "id": "b8,Vl{BJ|A];nmgz.siE",
                                  "type": "teamtag_get"
                                }
                              }
                            },
                            "type": "function_call"
                          }
                        },
                        "type": "function_call"
                      }
                    },
                    "type": "debug"
                  }
                },
                "IF0": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "z@IQ9C7cM[YBM}oGRSMU",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;}]\"></mutation>",
                          "fields": {
                            "NAME": "boardMethod:GetUnitCount",
                            "THIS": false
                          },
                          "id": "iy2gzaBLq7{,T!2R:S^d",
                          "inputs": {
                            "ARG0": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "board",
                                  "VAR": {
                                    "id": "L@q(8,F!A.e-L01h4X40"
                                  }
                                },
                                "id": "Y9X!/K*ub},w-/}9~8n^",
                                "type": "variables_get"
                              }
                            }
                          },
                          "type": "function_call_return"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 0
                          },
                          "id": ";Se8JI}Z7ppj$w(~3%.^",
                          "type": "math_number"
                        }
                      }
                    },
                    "type": "logic_compare"
                  }
                }
              },
              "type": "controls_if"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "EQ"
              },
              "id": "}o%DEqX]1YhKVAL8vWM_",
              "inputs": {
                "A": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "board",
                      "VAR": {
                        "id": "*q*vmVb.4T8slLn+bz]^"
                      }
                    },
                    "id": "Zu1k2fJyiMfpLLjASt~{",
                    "type": "variables_get"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "NUM": 1
                    },
                    "id": ":Lw`j]*{lQ=rHs{sOJD2",
                    "type": "math_number"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": 665,
        "y": 965
      },
      {
        "id": "vUemD~Z}h03y8_p{6mpY",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
              "fields": {
                "NAME": "boardMethod:AddUnit",
                "THIS": true
              },
              "id": "yE5zA1JQ:[`w.[1;HZ{M",
              "inputs": {
                "ARG0": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "board",
                      "VAR": {
                        "id": "L@q(8,F!A.e-L01h4X40"
                      }
                    },
                    "id": "uEf/Z#?`b6+!g`!+[C-j",
                    "type": "variables_get"
                  }
                },
                "ARG2": {
                  "block": {
                    "fields": {
                      "OP": "ADD"
                    },
                    "id": "7B;!*Jr19GBPy7I%v@=!",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "p*CV16?3AJ6I1w~7r*GC"
                            }
                          },
                          "id": "s~JKKIjQ5iKKz:j.YsvL",
                          "type": "variables_get"
                        },
                        "shadow": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "rM9TB?,)Ct1in^H*|W8=",
                          "type": "math_number"
                        }
                      },
                      "B": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "m`mJ,bwPq{s#8-wS%5=t"
                            }
                          },
                          "id": ")VM0UjU!0wiQ8rzp/=e7",
                          "type": "variables_get"
                        },
                        "shadow": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "{FXo1y5lk,x/c!]FBh.,",
                          "type": "math_number"
                        }
                      }
                    },
                    "type": "math_arithmetic"
                  }
                },
                "ARG4": {
                  "block": {
                    "fields": {
                      "NUM": 0
                    },
                    "id": "eg2Iy|4Qi,P[a3IdsILe",
                    "type": "math_number"
                  }
                },
                "ARG5": {
                  "block": {
                    "fields": {
                      "VAR": "Enemy"
                    },
                    "id": "@~UU^SE{x8)VrnV?FW`e",
                    "type": "teamtag_get"
                  }
                },
                "ARG6": {
                  "block": {
                    "fields": {
                      "NUM": 1
                    },
                    "id": "m@C#:v0yz?aEv8bmqLz]",
                    "type": "math_number"
                  }
                }
              },
              "next": {
                "block": {
                  "fields": {
                    "TYPE": "board",
                    "VAR": {
                      "id": "*q*vmVb.4T8slLn+bz]^"
                    }
                  },
                  "id": "_222RVobQ=*!kSP}a)hQ",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "NUM": 1
                        },
                        "id": "b:*#qSwU_dV:uK^=#XI2",
                        "type": "math_number"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "fields": {
                        "TYPE": "board",
                        "VAR": {
                          "id": "0G%FG`7su~T$D{R#ch,-"
                        }
                      },
                      "id": "yDxrvL1z]l$s?)ZHKgTK",
                      "inputs": {
                        "VALUE": {
                          "block": {
                            "fields": {
                              "NUM": 1
                            },
                            "id": "2z3hmTvRH.YR2}ZlWRc%",
                            "type": "math_number"
                          }
                        }
                      },
                      "next": {
                        "block": {
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "`k=eg*7EfVTN{g=#$Jd;"
                            }
                          },
                          "id": "B`,g~$vkdE7ZI)eca{N`",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "$uoJul8$n+,R_3)vjDqh",
                                "type": "math_number"
                              }
                            }
                          },
                          "next": {
                            "block": {
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": "sTnZeu7)afyZ}t;wNl3O"
                                }
                              },
                              "id": "lj+am+89W?cck?SA::B/",
                              "inputs": {
                                "VALUE": {
                                  "block": {
                                    "fields": {
                                      "NUM": 1
                                    },
                                    "id": "P#7mn]])hzKG~m@PI(,0",
                                    "type": "math_number"
                                  }
                                }
                              },
                              "next": {
                                "block": {
                                  "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                                  "fields": {
                                    "NAME": "boardMethod:UnBlockMoveAction",
                                    "THIS": false
                                  },
                                  "id": "weNqd4.jG?O8_[{=vrWO",
                                  "type": "function_call"
                                }
                              },
                              "type": "variables_set"
                            }
                          },
                          "type": "variables_set"
                        }
                      },
                      "type": "variables_set"
                    }
                  },
                  "type": "variables_set"
                }
              },
              "type": "function_call"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "AND"
              },
              "id": "w0o_a_Es0PaEWExl+lRc",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "~EeY@!#-Nih]x%q$g=EP",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                          "fields": {
                            "NAME": "boardMethod:GetBoardState",
                            "THIS": true
                          },
                          "id": "a*R`B9|-9GOUZ#fk}_q)",
                          "type": "function_call_return"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "VAR": "2001"
                          },
                          "id": "M]n?5GO!,8f~?lt`/n?M",
                          "type": "gameboardstates_get"
                        }
                      }
                    },
                    "type": "logic_compare"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "_e!7oMqIbprC3fY1{mg]",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "*q*vmVb.4T8slLn+bz]^"
                            }
                          },
                          "id": "Yj]1E]}[/12{8Zf+kxgL",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 0
                          },
                          "id": "+%~REKV83oJ$?J}A{{(n",
                          "type": "math_number"
                        }
                      }
                    },
                    "type": "logic_compare"
                  }
                }
              },
              "type": "logic_operation"
            }
          }
        },
        "type": "controls_if",
        "x": 645,
        "y": -95
      },
      {
        "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
        "fields": {
          "NAME": "boardMethod:GetMainPlayerUnit",
          "THIS": true
        },
        "id": "T,ZOcd-B@L%rNqYUu+bM",
        "next": {
          "block": {
            "id": "Z(N3DLKATN[^B9]gIQIU",
            "inputs": {
              "DO0": {
                "block": {
                  "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;name&quot;:&quot;BoardState&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "boardMethod:SetBoardState",
                    "THIS": true
                  },
                  "id": "T`o/eq:jb(rxQUYxPC9W",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "fields": {
                          "VAR": "1002"
                        },
                        "id": "V!ZuZ7BVF8i#O71Vq^cd",
                        "type": "gameboardstates_get"
                      }
                    }
                  },
                  "type": "function_call"
                }
              },
              "IF0": {
                "block": {
                  "fields": {
                    "OP": "AND"
                  },
                  "id": "Mg|]H6:z(;{OV9RaBp]t",
                  "inputs": {
                    "A": {
                      "block": {
                        "fields": {
                          "OP": "EQ"
                        },
                        "id": "O3?WLH1v7.9P#pcOLRaS",
                        "inputs": {
                          "A": {
                            "block": {
                              "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                              "fields": {
                                "NAME": "boardMethod:GetBoardState",
                                "THIS": true
                              },
                              "id": "5Xl.~6DPlAmPWCixyhLN",
                              "type": "function_call_return"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "VAR": "1001"
                              },
                              "id": "!M%m{CV0~!FDeabQ3.tQ",
                              "type": "gameboardstates_get"
                            }
                          }
                        },
                        "type": "logic_compare"
                      }
                    },
                    "B": {
                      "block": {
                        "fields": {
                          "OP": "EQ"
                        },
                        "id": "JC8MJ_[2dsuLv/f%IlIg",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "THIS": false,
                                "VAR": "unitVariable:FreeRollCount"
                              },
                              "id": "B^pC;[]H$du0OQpWn@LB",
                              "type": "variables_get_reserved"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "NUM": 0
                              },
                              "id": "@#Siki6KeumL#W~0g^?`",
                              "type": "math_number"
                            }
                          }
                        },
                        "type": "logic_compare"
                      }
                    }
                  },
                  "type": "logic_operation"
                }
              }
            },
            "type": "controls_if"
          }
        },
        "type": "function_call",
        "x": 645,
        "y": -305
      },
      {
        "id": "lA^LS.y-o:^t[$wy=15X",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "TYPE": "board",
                "VAR": {
                  "id": "0G%FG`7su~T$D{R#ch,-"
                }
              },
              "id": "*BJ@S]B}C*3I;MxK*,+^",
              "inputs": {
                "VALUE": {
                  "block": {
                    "fields": {
                      "NUM": 0
                    },
                    "id": "B2TAUgL#)u#;c(DsHAWS",
                    "type": "math_number"
                  }
                }
              },
              "next": {
                "block": {
                  "fields": {
                    "TYPE": "board",
                    "VAR": {
                      "id": "`k=eg*7EfVTN{g=#$Jd;"
                    }
                  },
                  "id": "RAY.?)UrKxaQJjmaW7-*",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "NUM": 2
                        },
                        "id": "YwfZBCkFwk?.1/f+b86D",
                        "type": "math_number"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                      "fields": {
                        "NAME": "boardMethod:BlockMoveAction",
                        "THIS": false
                      },
                      "id": "1Hop5g$y`T?S[=sFF;]I",
                      "next": {
                        "block": {
                          "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;name&quot;:&quot;PlayerId&quot;},{&quot;comment&quot;:&quot;웨이브 숫자 (시작 웨이브가 1)&quot;,&quot;name&quot;:&quot;Offset&quot;},{&quot;comment&quot;:&quot;이벤트 문자열 키&quot;,&quot;name&quot;:&quot;StringKey&quot;}]\"></mutation>",
                          "fields": {
                            "NAME": "boardMethod:SendWaveStartedEvent",
                            "THIS": false
                          },
                          "id": "k;GRicJO4(8{tEMK7;q4",
                          "type": "function_call"
                        }
                      },
                      "type": "function_call"
                    }
                  },
                  "type": "variables_set"
                }
              },
              "type": "variables_set"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "AND"
              },
              "id": "om-?U^JU|@UPp7q`%cNm",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "LTE"
                    },
                    "id": "E~.?CD;pQ9KstDJ$!}_~",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "NUM": 12
                          },
                          "id": "u{`]*tv.wub[q|J.x!mz",
                          "type": "math_number"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "5[oPwA[ob^VfP$Dtgi0P",
                          "inputs": {
                            "A": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "board",
                                  "VAR": {
                                    "id": "p*CV16?3AJ6I1w~7r*GC"
                                  }
                                },
                                "id": "VYA%8lM~Wa%KQh=l!R`S",
                                "type": "variables_get"
                              },
                              "shadow": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "zo,]kl%7+GJz9pr#U0IY",
                                "type": "math_number"
                              }
                            },
                            "B": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "board",
                                  "VAR": {
                                    "id": "B-q~25Q,EZ.zGd3S8Fl["
                                  }
                                },
                                "id": "YPntm*ov@11,Rv{A7$^0",
                                "type": "variables_get"
                              },
                              "shadow": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "mPJB%B`RAY)9n8tjDScG",
                                "type": "math_number"
                              }
                            }
                          },
                          "type": "math_arithmetic"
                        }
                      }
                    },
                    "type": "logic_compare"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "u6}R?gOxHd%DJpj6WZ7V",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "`k=eg*7EfVTN{g=#$Jd;"
                            }
                          },
                          "id": "T(,$nFSfe)4TmZO1_bs^",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "Zg_k0%yywBNjeJoKZ@UG",
                          "type": "math_number"
                        }
                      }
                    },
                    "type": "logic_compare"
                  }
                }
              },
              "type": "logic_operation"
            }
          }
        },
        "type": "controls_if",
        "x": 655,
        "y": 485
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Map_ChargeDungeon_Update",
    "period": "15",
    "triggerType": "1"
  },
  "scroll": {},
  "variables": [
    {
      "id": "rt:#jgP8$hd^]jZV!:#M",
      "name": "Gem"
    },
    {
      "id": ";!/+GYBZd;P?1n6,vrn|",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "(tbt!1.Sa.-h9%ih+9-H",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "AgP0_]w3XTCg-2%DsQV8",
      "name": "Unit/Time01"
    },
    {
      "id": "K^.yjQ1@iRB;2ZLBxG-P",
      "name": "Unit/Time02"
    },
    {
      "id": "HN!qvkXg=8S$J/v[r{S.",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "h`3((MC-e|j5%DcH^;XR",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "7db1iLdlOsYf2/fF*:+n",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "B-q~25Q,EZ.zGd3S8Fl[",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "p*CV16?3AJ6I1w~7r*GC",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "%t40zVp-{iRCM)Gs^#4l",
      "name": "Unit/Tick"
    },
    {
      "id": "p?e,,fV)5jw$XHBLz)a)",
      "name": "Unit/Rome"
    },
    {
      "id": ")d2/~,Wil@Gi9/b3ZUOp",
      "name": "@Unit/Delay"
    },
    {
      "id": "h*YynKpkz0Sc^+|^[PNR",
      "name": "@Unit/Range01"
    },
    {
      "id": "I*W]{SfJ@j[6Ec!,FqH.",
      "name": "@Unit/Range02"
    },
    {
      "id": "AilaQ=U;V!YV$5Y8ji-^",
      "name": "@Unit/Range03"
    },
    {
      "id": "t]UD8d5qL9fqYLC6H!(N",
      "name": "@Unit/Range04"
    },
    {
      "id": "p9{7bj@UX,TKn(ZH+zoY",
      "name": "@Unit/Range05"
    },
    {
      "id": "Du9XMoMNUeg_8A/SUy:g",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "G(A=SgM-4(cRD|`,zU09",
      "name": "@Unit/Variable01"
    },
    {
      "id": "%)lq/oJpw-KbG0!OY!NG",
      "name": "@Unit/Variable02"
    },
    {
      "id": "-p$FLI[kUJ:yLLuIV]`i",
      "name": "@Unit/Variable03"
    },
    {
      "id": "r0]uI:Z{Lr3Ib#ZIMpdC",
      "name": "@Unit/Variable04"
    },
    {
      "id": "/bJeq.j4,KY%5@Prw%T[",
      "name": "@Unit/Variable05"
    },
    {
      "id": "or(#VNF:]TYQ49%$tRV7",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "8cxHTIyOL`;2LCE^W1mw",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "5T9-{_MWd3@#Jz!hp_ZZ",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "^h8jwblCtTaTbB3PzRt]",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "_E(caq,+vz9}x{3)-FD:",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "R;#oW~5-@(I,V#y:r3ik",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "HG?cfiYmkGt5{Eo:vYEM",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "KL9NC:r!F-y/$W}!Zb2f",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "gfM{eH^*CiM~e:a/=;)W",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "AU+B{CElL=1|8iOS3DU|",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "m`mJ,bwPq{s#8-wS%5=t",
      "name": "@Map/Variable01"
    },
    {
      "id": "ZGx{TEJ/CN=%K/lQebF;",
      "name": "@Map/Variable02"
    },
    {
      "id": "n:d-R}AkzZ7t1*W`XhDM",
      "name": "@Map/Variable03"
    },
    {
      "id": "F4OX3:?3Ok|-CZbw{,y9",
      "name": "@Map/Variable04"
    },
    {
      "id": "0O?atJ405|6RT|rfrmrp",
      "name": "@Map/Variable05"
    },
    {
      "id": "*`-HAO_Qs9b5zfv{n}qz",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "*q*vmVb.4T8slLn+bz]^",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "k`P?0-iX,dxJ/z)gSI(B",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "~t{RcG5kE+)6a=6Ur:vG",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "F`Tgy]Q(y@~@e)l{fFC`",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "DgZXq*VvcNDS|K3LL_3a",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "%`%Ub]i=v+q;I{Ol379c",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "tNdORo/LGF+1I)WO:I,4",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "2lCZv]3.JHEh1+GYec/C",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "EWQo?U1|,60~WN~?pvUU",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "5YM13c@ZM?qORsZLma_N",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "RxLfn6oU-_Vpk:WSd=ue",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "G`j~^-Dp+{?1pwfs+6zp",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": ")+xi_SZ9^e}3_VgAnceK",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "1K@FEI?#oMiiEG,__66I",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "gSPp^Q#@,c|S3n$y;QyE",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "sTnZeu7)afyZ}t;wNl3O",
      "name": "Map/Wave"
    },
    {
      "id": "dsP%(`9+wy[eD7|{G9fq",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "N50$#3}.qT#=XYSh{#{Z",
      "name": "Map/IsClear"
    },
    {
      "id": "13{o7JU{.DdGG]o4iUYu",
      "name": "Map/Wave/Step"
    },
    {
      "id": "W$wN{,.PJO:?Z`S?1wAA",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "Tp73zg)s-H@wHd#%zZ}e",
      "name": "Map/IsSpawn"
    },
    {
      "id": "IOnPF?)aZn7KK;L+pKH~",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "(I5NKEDcMr}Rz?+d!Qg}",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "`k=eg*7EfVTN{g=#$Jd;",
      "name": "Map/Wave/State"
    },
    {
      "id": ")}qsPp7=06{77T%rSZ~G",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "PCSA+(#4Z8B!zG?0g+yg",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "99)+6vQzI_7htK9AboW-",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "2av_0)eK!^cv#@[CZAtO",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "T3aVs8C!$q6lJ,(rCo76",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "N+qUj-{G7CBQCw(Q$J@c",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "-Es.b5uPd6NEK5A$.2W8",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": ";09]?knp03G=wh`#xEsl",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "WUR.YN,dp:MfM_Yix)e2",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "B(y;X8vc=3_b}2TFnkjM",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "]-!;eMKBi)ed!#vnx}TB",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "Ig4e~fqEZ69AKGqCIOFy",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "-T?{2CDabq,fx|yiDZ;$",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "Jlq4v05)TKgdp#u+}Wgg",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "/hzDg`|3~b8$?*EECq(8",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "79ka4]ej|#=5*+sq;`C,",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "fwKGAM@OsX%n0Fj56rEb",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": ".kac{9U4zUrll|CkD*}@",
      "name": "@Skill/Variable/01"
    },
    {
      "id": ";::sN2x%(:`]r(3R9h0W",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "s$5jTa}.m2L7Rb(vs(^%",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "(dgCpo(|O!.GItIA-!tL",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "*8O;c+pK?|ODo0X-tA0U",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "AAYHE,.Ak@ZlmDrMQEYu",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": ";f^#[H`}fO)8HhVmD1(?",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "RwiY5f@ILEq-nK4Our9Q",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "L@q(8,F!A.e-L01h4X40",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "jBA!m6J2Iu4~wiZ$bYq*",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "yQ[~RuWgks-{aJ(==rDL",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "Yi0#XHYaog6aTrs)7-x1",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "~Vnzk:/8@pW~G2+4P,!z",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "J4i:}ziOOGW(}VU=3g09",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "t{Pv,xMvH@9`%nN:xk]O",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "V1-tfUd#X4!:$2RCd#Ue",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": ":Sm`H+ZV42.F{NR,L+x)",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "]6uy%mY39qE_*pLn|gY`",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "L:[]x$,ylRx1eK9zq,/_",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "t|y8[+TK!M8h^z_uhtMy",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": ":/m.sgsmU)vY%lOF+RIh",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "*djuh#mK}_Y,/[XcV-uy",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "w:V|-(/C5DQHfM#A{E.T",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "Sv1Lv_9ZCPEfqa/m;u}6",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "}Dc!,#WCCPns1onDguGv",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "dBKs1N=8XZMi$pw4/:aq",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "{:1EOck#k80DEGW)IN1X",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": ")k:W1~O~K|y6u1yP/.Px",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "9wa5E~-,d*jX1W68cqGl",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "}v#vmg?PX7@Qx*P=?;e9",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "t[;%=2,RXKPc/)0ub0i+",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "(OD!=*i(FRplAN|f@Tya",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": ":Ev[Y}(-balzP,s0[nK.",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "M8StR_RG75PQt.T7{?v:",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "03*b,NbNBH8BOua:G^=G",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "VlwaSw/aeWe2V#XQlKGI",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "YfE/W$Kzz4IiFC#:SE3T",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "l#MbQrDt]-[jl-mNsg~y",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "@V@58)Qsel/~kOPQAcpv",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "/aAIg*IXKfbpPBItqB]C",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "U8^YoBaM2|m!BH8.mSXi",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "u-{z~)=,ZrDmzo%].}1}",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "e@u|3lutjp;KKb,?[?~c",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "jD5$nBhD}*:1(@Zb$,x*",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "r-|91#s`iO9O9t`!JCPs",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "_.tA_cBsmKoSi3^#mT_M",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "nCnNd5hUv={sTm?g#{%[",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "_ohNl0%/3#:j$VFLW2.M",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "p-6Msr3a3RltsE9B.@B2",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "!Y0|MJ*_rU-T{NB+Hj/1",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "/8m5r1@g^~i~d!c?eKHS",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "*lYH~hhksQ;FsZ,DGstr",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "IOu.ZxdilR1?a:u@4b2I",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "}Ps!*/zARiyLRl,t`]$S",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "rh`Y-/$;H$kGrDBtS0lF",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "k}.2I!q}`]1eo8yG@9IS",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "TRhppa|[GGyt:i~/.9gn",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "KEyzT!TG577Y@f7++YF/",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "E+a|ECJhRq,F}*%=e_`W",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": ",`m5K20NI;td9%|A|$wk",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "9cL:c:^TZ{T!.4vO[y9G",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "l$aU*ran*.nCfTWbBX?=",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "#4U?D8Z_mQD#qOY98+Oy",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "=k83Ph5=;IH|+T~+e[w9",
      "name": "Map/IsStart"
    },
    {
      "id": "{3f{M(~=@{l{G2v$+EpC",
      "name": "Map/WaveCount"
    },
    {
      "id": "V3!I#9ZxGNJUFfqc$Uyk",
      "name": "Map/BattleValue"
    },
    {
      "id": "tL[1]:dB=t(#rsyTP!`H",
      "name": "Map/CanStart"
    },
    {
      "id": "Ok^Z.;D;kYd@Km`mlu[$",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "0G%FG`7su~T$D{R#ch,-",
      "name": "Map/Player/Moving"
    },
    {
      "id": "kwceBc:Db/|7+4x@ln*D",
      "name": "🚨 Scout rewards maxed out!\nCollect Gold💰 & Gems💎, and power up!\nPlay Hamster Combat now! 👉 [Play Now]"
    },
    {
      "id": "DoQpZ{Ac`*pg22r,OFuy",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "Gwm?|}=x:o+96%I)-d@P",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "MqB,e]B}qL*@_2+iaJkK",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": ".8fJ_o2%E##mAX?#tT7_",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "Vo]4ADZjt36-r21Wy,[@",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "2!-CaE[W,B)N=I2FaZaM",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "`L})^j^nhZfz{^F`obT8",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "9,bwCz$kwFb3$DZnL_1T",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "RxjPCl.iSst5apUU4{]w",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "8k-?)7Cm}.4IjS}fhLWi",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "w+Z*2MHvmnvZ%O5?iX1!",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "nXoyUl1:cH3M[Zr~T(TA",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "c79Sdeb{8(agUA!NkO#}",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "co?rH=47=+4Jqq{%32xx",
      "name": "@Map/Progress"
    },
    {
      "id": "1dFL1[RvbGA8YzSZ4Vl3",
      "name": "Map/DisplayWinningTeam"
    },
    {
      "id": "Yt?Ntqp!)vu5q,KVwp0p",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "zYjBBXSs3.,xe==llXTd",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "(TWYmvZyvjhL^O/@Wr,:",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "8@]7^-3HM8;1/l.}p@WJ",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "+ugglP1mz{uhbOXR)Xvq",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "%c67V8,mg7r-$dNV=%`(",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "??dAR50P{H|t#9W7+CU{",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "Z-y7(.F]cj.8N[Tt39j}",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "MZ+~Nv~o6XRpLBzl+RY`",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "%..K*y0R89`]z?P_ZkQX",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "(ft/XP:_N%{iC4H:O0@U",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "CRsgINN/?R3t_f$cF`(Q",
      "name": "@Map/WaveStartPlayerPosition"
    }
  ]
}