{
  "blocks": {
    "blocks": [
      {
        "fields": {
          "NAME": "Map_Default3_Wave2",
          "THIS": true
        },
        "id": "U)a;=BEs#,=l(htM#nfX",
        "next": {
          "block": {
            "fields": {
              "NAME": "Map_Default3_Wave3",
              "THIS": true
            },
            "id": "tqf4}.J~NnK,nqUY.KJr",
            "next": {
              "block": {
                "id": "RVP*E|?|PgD[Tw@nP%Ed",
                "inputs": {
                  "DO0": {
                    "block": {
                      "fields": {
                        "TYPE": "board",
                        "VAR": {
                          "id": "z)yxQeEWT^SXZ.ll$bde"
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
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "o,xKeQe}t5}Q]cui@aQG"
                            }
                          },
                          "id": ":%kO~6ylQJp,sW-FP+1f",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "BOOL": "FALSE"
                                },
                                "id": "U5]6QQ4o(E?i5`yS0A2/",
                                "type": "logic_boolean"
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
                              "id": "JS2ca5d:[$zk!K4%HsP2",
                              "next": {
                                "block": {
                                  "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                                  "fields": {
                                    "NAME": "boardMethod:BlockSkillAction",
                                    "THIS": false
                                  },
                                  "id": "+tBx)Trp9SmrBbu;g,0J",
                                  "next": {
                                    "block": {
                                      "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;name&quot;:&quot;BoardState&quot;}]\"></mutation>",
                                      "fields": {
                                        "NAME": "boardMethod:SetBoardState",
                                        "THIS": false
                                      },
                                      "id": "=~f.|d:ad,Z0K@4;4Q~#",
                                      "inputs": {
                                        "ARG0": {
                                          "block": {
                                            "fields": {
                                              "VAR": "2001"
                                            },
                                            "id": "@(}`BFC#/Kx-6KC9Vhm~",
                                            "type": "gameboardstates_get"
                                          }
                                        }
                                      },
                                      "next": {
                                        "block": {
                                          "fields": {
                                            "TYPE": "board",
                                            "VAR": {
                                              "id": "?4,(tFHY[rrPt/GzpTj)"
                                            }
                                          },
                                          "id": "lZ(l@Y0ms=%HuT_K=)aa",
                                          "inputs": {
                                            "VALUE": {
                                              "block": {
                                                "fields": {
                                                  "NUM": 1
                                                },
                                                "id": "TH./UDooE!vutGtd@(1-",
                                                "type": "math_number"
                                              }
                                            }
                                          },
                                          "type": "variables_set"
                                        }
                                      },
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
                      "type": "variables_set"
                    }
                  },
                  "IF0": {
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
                                "id": "z)yxQeEWT^SXZ.ll$bde"
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
                  }
                },
                "type": "controls_if"
              }
            },
            "type": "trigger_call"
          }
        },
        "type": "trigger_call",
        "x": 1185,
        "y": -855
      },
      {
        "id": "lA^LS.y-o:^t[$wy=15X",
        "inputs": {
          "DO0": {
            "block": {
              "id": "r=$`E7.[,=+GT3fA{uU+",
              "inputs": {
                "DO0": {
                  "block": {
                    "fields": {
                      "NAME": "Log"
                    },
                    "id": "8IL_(@s~-V4eXKHh4rCB",
                    "inputs": {
                      "TEXT": {
                        "block": {
                          "fields": {
                            "TEXT": "Default3_Battle_01_01"
                          },
                          "id": "cqPJ0fK)(9r!V9%?liMJ",
                          "type": "text"
                        }
                      }
                    },
                    "next": {
                      "block": {
                        "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Duration (필수)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
                        "fields": {
                          "NAME": "boardMethod:StartTimer",
                          "THIS": false
                        },
                        "id": "y{/})L3x`jOv2VudKGD/",
                        "inputs": {
                          "ARG0": {
                            "block": {
                              "fields": {
                                "NUM": 3
                              },
                              "id": "]gsl)O?I1ZOy2R3FKw90",
                              "type": "math_number"
                            }
                          }
                        },
                        "next": {
                          "block": {
                            "fields": {
                              "TYPE": "board",
                              "VAR": {
                                "id": "6ji6Z$As$U=?*^_`Bmp~"
                              }
                            },
                            "id": "TSiy|pz]/LDP$;CNa8-^",
                            "inputs": {
                              "VALUE": {
                                "block": {
                                  "fields": {
                                    "THIS": false,
                                    "VAR": "boardVariable:Tick"
                                  },
                                  "id": "D2tv%s{_mcL23#);{LIS",
                                  "type": "variables_get_reserved"
                                }
                              }
                            },
                            "next": {
                              "block": {
                                "fields": {
                                  "TYPE": "board",
                                  "VAR": {
                                    "id": "Ek:5yv3s|PF-]xi{ROQM"
                                  }
                                },
                                "id": "Z?6ViJ0?ZAX,YO*C0KR_",
                                "inputs": {
                                  "VALUE": {
                                    "block": {
                                      "fields": {
                                        "NUM": 1
                                      },
                                      "id": "eWJ:0:5$T/^@vyXsy_NV",
                                      "type": "math_number"
                                    }
                                  }
                                },
                                "next": {
                                  "block": {
                                    "fields": {
                                      "TYPE": "board",
                                      "VAR": {
                                        "id": "haV+evEyYXpN85{NOBM_"
                                      }
                                    },
                                    "id": "]9,b0lA5HjuRH}3.iaYS",
                                    "inputs": {
                                      "VALUE": {
                                        "block": {
                                          "fields": {
                                            "OP": "ADD"
                                          },
                                          "id": "X;?HX_-W)YQ-~Lh@hW8p",
                                          "inputs": {
                                            "A": {
                                              "block": {
                                                "fields": {
                                                  "THIS": false,
                                                  "VAR": "boardVariable:Tick"
                                                },
                                                "id": "Tc6qoqh)Nq_w79,Q]q-$",
                                                "type": "variables_get_reserved"
                                              },
                                              "shadow": {
                                                "fields": {
                                                  "NUM": 1
                                                },
                                                "id": "bUrKDpRP0p{%{3I2weka",
                                                "type": "math_number"
                                              }
                                            },
                                            "B": {
                                              "shadow": {
                                                "fields": {
                                                  "NUM": 2400
                                                },
                                                "id": ";.vlH/Dj?4en=$3;v*2/",
                                                "type": "math_number"
                                              }
                                            }
                                          },
                                          "type": "math_arithmetic"
                                        }
                                      }
                                    },
                                    "next": {
                                      "block": {
                                        "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;name&quot;:&quot;PlayerId&quot;},{&quot;comment&quot;:&quot;웨이브 숫자 (시작 웨이브가 1)&quot;,&quot;name&quot;:&quot;Offset&quot;},{&quot;comment&quot;:&quot;이벤트 문자열 키&quot;,&quot;name&quot;:&quot;StringKey&quot;}]\"></mutation>",
                                        "fields": {
                                          "NAME": "boardMethod:SendWaveStartedEvent",
                                          "THIS": false
                                        },
                                        "id": "k;GRicJO4(8{tEMK7;q4",
                                        "next": {
                                          "block": {
                                            "fields": {
                                              "TYPE": "board",
                                              "VAR": {
                                                "id": "o,xKeQe}t5}Q]cui@aQG"
                                              }
                                            },
                                            "id": "ZZ[OBR_96wA|eyycpE*_",
                                            "inputs": {
                                              "VALUE": {
                                                "block": {
                                                  "fields": {
                                                    "BOOL": "TRUE"
                                                  },
                                                  "id": "*_;7Y|[I,R,x!`U.K=xG",
                                                  "type": "logic_boolean"
                                                }
                                              }
                                            },
                                            "type": "variables_set"
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
                            "type": "variables_set"
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
                    "id": "e]p)%Rw%X_B{0]zD0Xd^",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": ";H`vkq^C/W8IdRJ-#jIW"
                            }
                          },
                          "id": "-vGv3gW0R!N!2MFeuMkj",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 0
                          },
                          "id": ")bb]%kh0`.4/E@D1mj@:",
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
                "OP": "AND"
              },
              "id": "om-?U^JU|@UPp7q`%cNm",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "GY-}N(c{x(hL|j1{FD$(",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "o,xKeQe}t5}Q]cui@aQG"
                            }
                          },
                          "id": "MM`Q,3Gpb`pKM=uN9{52",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "BOOL": "FALSE"
                          },
                          "id": "-o)R9Ln~}CBC@gPVj^X`",
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
                    "id": "u6}R?gOxHd%DJpj6WZ7V",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "Ek:5yv3s|PF-]xi{ROQM"
                            }
                          },
                          "id": "T(,$nFSfe)4TmZO1_bs^",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 0
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
        "x": 1175,
        "y": -415
      },
      {
        "id": "!d:N[i.8lO;cB3{JMQ-;",
        "inputs": {
          "DO0": {
            "block": {
              "id": "$PG[SP*1b=~q4nl3)IYb",
              "inputs": {
                "DO0": {
                  "block": {
                    "id": "6F?WwkU?%Hm+D0m1wKGh",
                    "inputs": {
                      "DO0": {
                        "block": {
                          "id": "F:H]0{sg)#O,jL?X7oUR",
                          "inputs": {
                            "DO0": {
                              "block": {
                                "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                "fields": {
                                  "NAME": "boardMethod:AddUnit",
                                  "THIS": true
                                },
                                "id": "*i14c3g[aBPU~}PmQ8IL",
                                "inputs": {
                                  "ARG0": {
                                    "block": {
                                      "extraState": "<mutation></mutation>",
                                      "fields": {
                                        "TYPE": "board",
                                        "VAR": {
                                          "id": "1ZxWa$PmVjUk0t$,8x~S"
                                        }
                                      },
                                      "id": "ko/RKS#M5@m-fgL9SEjB",
                                      "type": "variables_get"
                                    }
                                  },
                                  "ARG2": {
                                    "block": {
                                      "fields": {
                                        "OP": "ADD"
                                      },
                                      "id": "Gp(P51{w8cl4]jcn^fzt",
                                      "inputs": {
                                        "A": {
                                          "block": {
                                            "extraState": "<mutation></mutation>",
                                            "fields": {
                                              "TYPE": "board",
                                              "VAR": {
                                                "id": "y%%l?*_%JXp)m~Jd[vzT"
                                              }
                                            },
                                            "id": "?@?XS!$ZqTS[s}fp*Cn0",
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
                                            "fields": {
                                              "OP": "ADD"
                                            },
                                            "id": "?6RTL@Ud?c6ton0b9v]S",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "extraState": "<mutation></mutation>",
                                                  "fields": {
                                                    "TYPE": "board",
                                                    "VAR": {
                                                      "id": "@qS80$GZMo@v]=FG(Z#]"
                                                    }
                                                  },
                                                  "id": ")VM0UjU!0wiQ8rzp/=e7",
                                                  "type": "variables_get"
                                                },
                                                "shadow": {
                                                  "fields": {
                                                    "NUM": 1
                                                  },
                                                  "id": ":lSZLtqdeq3).g3NNN]b",
                                                  "type": "math_number"
                                                }
                                              },
                                              "B": {
                                                "block": {
                                                  "fields": {
                                                    "OP": "MULTIPLY"
                                                  },
                                                  "id": "P9c%6(u*k$FB]=Ud6ynT",
                                                  "inputs": {
                                                    "A": {
                                                      "block": {
                                                        "fields": {
                                                          "OP": "ADD"
                                                        },
                                                        "id": "[l:r%CgzkNflhJ3PCAnH",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "fields": {
                                                                "THIS": false,
                                                                "VAR": "unitVariable:VelocityX"
                                                              },
                                                              "id": "Xu?-tpI*%r,%=d?A22.c",
                                                              "type": "variables_get_reserved"
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
                                                              "fields": {
                                                                "NUM": 1.5
                                                              },
                                                              "id": "2VPMEo1QA*sU!R*`ci/n",
                                                              "type": "math_number"
                                                            },
                                                            "shadow": {
                                                              "fields": {
                                                                "NUM": 1
                                                              },
                                                              "id": "YL49n]P!_LlaD:})]nZh",
                                                              "type": "math_number"
                                                            }
                                                          }
                                                        },
                                                        "type": "math_arithmetic"
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
                                                        "fields": {
                                                          "NUM": 2
                                                        },
                                                        "id": "dYX.z|gQhf|8;?e_pGMJ",
                                                        "type": "math_number"
                                                      },
                                                      "shadow": {
                                                        "fields": {
                                                          "NUM": 1
                                                        },
                                                        "id": "YL49n]P!_LlaD:})]nZh",
                                                        "type": "math_number"
                                                      }
                                                    }
                                                  },
                                                  "type": "math_arithmetic"
                                                },
                                                "shadow": {
                                                  "fields": {
                                                    "NUM": 1
                                                  },
                                                  "id": "@-Z-!F0Qf^F:c%#4M7y{",
                                                  "type": "math_number"
                                                }
                                              }
                                            },
                                            "type": "math_arithmetic"
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
                                      "id": "9yTz*%r}sVv?4iygXLH[",
                                      "type": "math_number"
                                    }
                                  },
                                  "ARG5": {
                                    "block": {
                                      "fields": {
                                        "VAR": "Enemy"
                                      },
                                      "id": "}v(C:;bSL~H_gTPd=9tL",
                                      "type": "teamtag_get"
                                    }
                                  },
                                  "ARG6": {
                                    "block": {
                                      "fields": {
                                        "NUM": 1
                                      },
                                      "id": "#g4x?2yOO2C/84Q7gIqp",
                                      "type": "math_number"
                                    }
                                  }
                                },
                                "type": "function_call"
                              }
                            },
                            "IF0": {
                              "block": {
                                "fields": {
                                  "OP": "EQ"
                                },
                                "id": "deGcc{WsT+h6JW6%C.VG",
                                "inputs": {
                                  "A": {
                                    "block": {
                                      "id": "xr?i7{xCE4]QQwaXe54]",
                                      "inputs": {
                                        "DIVIDEND": {
                                          "block": {
                                            "fields": {
                                              "OP": "MINUS"
                                            },
                                            "id": "?IFj%S+Erg8IpNzLOu[;",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "fields": {
                                                    "THIS": false,
                                                    "VAR": "boardVariable:Tick"
                                                  },
                                                  "id": "%4}{rFARHdwQsnXZ#(Jx",
                                                  "type": "variables_get_reserved"
                                                },
                                                "shadow": {
                                                  "fields": {
                                                    "NUM": 1
                                                  },
                                                  "id": "O70iWAb8S^-9]7pq:A+`",
                                                  "type": "math_number"
                                                }
                                              },
                                              "B": {
                                                "block": {
                                                  "extraState": "<mutation></mutation>",
                                                  "fields": {
                                                    "TYPE": "board",
                                                    "VAR": {
                                                      "id": "6ji6Z$As$U=?*^_`Bmp~"
                                                    }
                                                  },
                                                  "id": "2,hN8+vz9PuEaOn_oONx",
                                                  "type": "variables_get"
                                                },
                                                "shadow": {
                                                  "fields": {
                                                    "NUM": 1
                                                  },
                                                  "id": "LS+usN:b4*JVXp@(=dCg",
                                                  "type": "math_number"
                                                }
                                              }
                                            },
                                            "type": "math_arithmetic"
                                          },
                                          "shadow": {
                                            "fields": {
                                              "NUM": 64
                                            },
                                            "id": "@b2dBX(r~i_RqQDD184k",
                                            "type": "math_number"
                                          }
                                        },
                                        "DIVISOR": {
                                          "shadow": {
                                            "fields": {
                                              "NUM": 105
                                            },
                                            "id": "Nm05SpDZPUbmEQ)aukW_",
                                            "type": "math_number"
                                          }
                                        }
                                      },
                                      "type": "math_modulo"
                                    }
                                  },
                                  "B": {
                                    "block": {
                                      "fields": {
                                        "NUM": 0
                                      },
                                      "id": "=rZ.VW`r4SXDrj_.U|{S",
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
                            "OP": "LTE"
                          },
                          "id": "S_mq}r`uTU!fgmLTD%XX",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "OP": "MINUS"
                                },
                                "id": "g|S3vE+o3QW1J@n!/{#h",
                                "inputs": {
                                  "A": {
                                    "block": {
                                      "fields": {
                                        "THIS": false,
                                        "VAR": "boardVariable:Tick"
                                      },
                                      "id": "[P/+_Z)l.nTyaTpC(dJH",
                                      "type": "variables_get_reserved"
                                    },
                                    "shadow": {
                                      "fields": {
                                        "NUM": 1
                                      },
                                      "id": "O70iWAb8S^-9]7pq:A+`",
                                      "type": "math_number"
                                    }
                                  },
                                  "B": {
                                    "block": {
                                      "extraState": "<mutation></mutation>",
                                      "fields": {
                                        "TYPE": "board",
                                        "VAR": {
                                          "id": "6ji6Z$As$U=?*^_`Bmp~"
                                        }
                                      },
                                      "id": "6#+[#KX|80{5A{;otV/K",
                                      "type": "variables_get"
                                    },
                                    "shadow": {
                                      "fields": {
                                        "NUM": 1
                                      },
                                      "id": "LS+usN:b4*JVXp@(=dCg",
                                      "type": "math_number"
                                    }
                                  }
                                },
                                "type": "math_arithmetic"
                              }
                            },
                            "B": {
                              "block": {
                                "fields": {
                                  "NUM": 2400
                                },
                                "id": "(=iis;kU0_niI595ZRC,",
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
                      "OP": "GTE"
                    },
                    "id": "q[Q%dDmxrWYYNFmeyLKf",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "lO]:%iuDDYA.5r}N@E?Z",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "THIS": false,
                                  "VAR": "boardVariable:Tick"
                                },
                                "id": "s1CkVn,|N2~K%$ew#xDP",
                                "type": "variables_get_reserved"
                              },
                              "shadow": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "O70iWAb8S^-9]7pq:A+`",
                                "type": "math_number"
                              }
                            },
                            "B": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "board",
                                  "VAR": {
                                    "id": "6ji6Z$As$U=?*^_`Bmp~"
                                  }
                                },
                                "id": "h,x--Qv{SS;oJl-L@2[{",
                                "type": "variables_get"
                              },
                              "shadow": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "LS+usN:b4*JVXp@(=dCg",
                                "type": "math_number"
                              }
                            }
                          },
                          "type": "math_arithmetic"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 0
                          },
                          "id": "xvDszpoeg~/qJ@=k5yjW",
                          "type": "math_number"
                        }
                      }
                    },
                    "type": "logic_compare"
                  }
                }
              },
              "next": {
                "block": {
                  "id": "i^:7x8W$55PvspQoZO,T",
                  "inputs": {
                    "DO0": {
                      "block": {
                        "id": "aG/w(}2{]MWQs}:p_?Bk",
                        "inputs": {
                          "DO0": {
                            "block": {
                              "id": "GV$N~m?YKowlxEY,[lAY",
                              "inputs": {
                                "DO0": {
                                  "block": {
                                    "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                    "fields": {
                                      "NAME": "boardMethod:AddUnit",
                                      "THIS": true
                                    },
                                    "id": "u$9/t#h.GZfxA}29.)z6",
                                    "inputs": {
                                      "ARG0": {
                                        "block": {
                                          "extraState": "<mutation></mutation>",
                                          "fields": {
                                            "TYPE": "board",
                                            "VAR": {
                                              "id": "1ZxWa$PmVjUk0t$,8x~S"
                                            }
                                          },
                                          "id": "Np[?XT^{-3IOMfF61D7c",
                                          "type": "variables_get"
                                        }
                                      },
                                      "ARG2": {
                                        "block": {
                                          "fields": {
                                            "OP": "ADD"
                                          },
                                          "id": "b;_uwD8I]*/TKDum@DSI",
                                          "inputs": {
                                            "A": {
                                              "block": {
                                                "extraState": "<mutation></mutation>",
                                                "fields": {
                                                  "TYPE": "board",
                                                  "VAR": {
                                                    "id": "y%%l?*_%JXp)m~Jd[vzT"
                                                  }
                                                },
                                                "id": ",q-`A:I;V@dMcU05prP=",
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
                                                "fields": {
                                                  "OP": "ADD"
                                                },
                                                "id": "oox$xf59_]bQj^v@BYaR",
                                                "inputs": {
                                                  "A": {
                                                    "block": {
                                                      "extraState": "<mutation></mutation>",
                                                      "fields": {
                                                        "TYPE": "board",
                                                        "VAR": {
                                                          "id": "@qS80$GZMo@v]=FG(Z#]"
                                                        }
                                                      },
                                                      "id": "9ANjQMmy9LU~6K{{x/IS",
                                                      "type": "variables_get"
                                                    },
                                                    "shadow": {
                                                      "fields": {
                                                        "NUM": 1
                                                      },
                                                      "id": ":lSZLtqdeq3).g3NNN]b",
                                                      "type": "math_number"
                                                    }
                                                  },
                                                  "B": {
                                                    "block": {
                                                      "fields": {
                                                        "OP": "MULTIPLY"
                                                      },
                                                      "id": ")S0U@Fu=l;kx^o%uAX1!",
                                                      "inputs": {
                                                        "A": {
                                                          "block": {
                                                            "fields": {
                                                              "OP": "ADD"
                                                            },
                                                            "id": "bgN`)1REm/r0CX(%l:hn",
                                                            "inputs": {
                                                              "A": {
                                                                "block": {
                                                                  "fields": {
                                                                    "THIS": false,
                                                                    "VAR": "unitVariable:VelocityX"
                                                                  },
                                                                  "id": "k|iYEa/aaK1aJ6Otgtdp",
                                                                  "type": "variables_get_reserved"
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
                                                                  "fields": {
                                                                    "NUM": 1.5
                                                                  },
                                                                  "id": "$Qc4{D1dR_zTaW_Fp23T",
                                                                  "type": "math_number"
                                                                },
                                                                "shadow": {
                                                                  "fields": {
                                                                    "NUM": 1
                                                                  },
                                                                  "id": "YL49n]P!_LlaD:})]nZh",
                                                                  "type": "math_number"
                                                                }
                                                              }
                                                            },
                                                            "type": "math_arithmetic"
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
                                                            "fields": {
                                                              "NUM": 2
                                                            },
                                                            "id": "_=~H*3l9As512h#xji.:",
                                                            "type": "math_number"
                                                          },
                                                          "shadow": {
                                                            "fields": {
                                                              "NUM": 1
                                                            },
                                                            "id": "YL49n]P!_LlaD:})]nZh",
                                                            "type": "math_number"
                                                          }
                                                        }
                                                      },
                                                      "type": "math_arithmetic"
                                                    },
                                                    "shadow": {
                                                      "fields": {
                                                        "NUM": 1
                                                      },
                                                      "id": "@-Z-!F0Qf^F:c%#4M7y{",
                                                      "type": "math_number"
                                                    }
                                                  }
                                                },
                                                "type": "math_arithmetic"
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
                                          "id": "MtCw4RYW@us+,H~06MQN",
                                          "type": "math_number"
                                        }
                                      },
                                      "ARG5": {
                                        "block": {
                                          "fields": {
                                            "VAR": "Enemy"
                                          },
                                          "id": "-!f$^jAE93[EIK^jOOE[",
                                          "type": "teamtag_get"
                                        }
                                      },
                                      "ARG6": {
                                        "block": {
                                          "fields": {
                                            "NUM": 1
                                          },
                                          "id": "@8R@h[m(`IlK5lZ0st[l",
                                          "type": "math_number"
                                        }
                                      }
                                    },
                                    "type": "function_call"
                                  }
                                },
                                "IF0": {
                                  "block": {
                                    "fields": {
                                      "OP": "EQ"
                                    },
                                    "id": "uQn=u?q%=pk%]A9;v(-G",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "id": "t31Jwj,^C=^-pi1IkBC#",
                                          "inputs": {
                                            "DIVIDEND": {
                                              "block": {
                                                "fields": {
                                                  "OP": "MINUS"
                                                },
                                                "id": ",/Pj+#fOg$i!ii^C36vG",
                                                "inputs": {
                                                  "A": {
                                                    "block": {
                                                      "fields": {
                                                        "THIS": false,
                                                        "VAR": "boardVariable:Tick"
                                                      },
                                                      "id": "Mw7aJ:kd1n~xRuSA:d~P",
                                                      "type": "variables_get_reserved"
                                                    },
                                                    "shadow": {
                                                      "fields": {
                                                        "NUM": 1
                                                      },
                                                      "id": "O70iWAb8S^-9]7pq:A+`",
                                                      "type": "math_number"
                                                    }
                                                  },
                                                  "B": {
                                                    "block": {
                                                      "extraState": "<mutation></mutation>",
                                                      "fields": {
                                                        "TYPE": "board",
                                                        "VAR": {
                                                          "id": "6ji6Z$As$U=?*^_`Bmp~"
                                                        }
                                                      },
                                                      "id": "uxy@:3pz@(.Rr1NZvp=u",
                                                      "type": "variables_get"
                                                    },
                                                    "shadow": {
                                                      "fields": {
                                                        "NUM": 1
                                                      },
                                                      "id": "LS+usN:b4*JVXp@(=dCg",
                                                      "type": "math_number"
                                                    }
                                                  }
                                                },
                                                "type": "math_arithmetic"
                                              },
                                              "shadow": {
                                                "fields": {
                                                  "NUM": 64
                                                },
                                                "id": "@b2dBX(r~i_RqQDD184k",
                                                "type": "math_number"
                                              }
                                            },
                                            "DIVISOR": {
                                              "shadow": {
                                                "fields": {
                                                  "NUM": 525
                                                },
                                                "id": "bg3H6a{.6izCdV~l^HT{",
                                                "type": "math_number"
                                              }
                                            }
                                          },
                                          "type": "math_modulo"
                                        }
                                      },
                                      "B": {
                                        "block": {
                                          "fields": {
                                            "NUM": 195
                                          },
                                          "id": "~8KTVW,H-315iM|jGFxh",
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
                                "OP": "LTE"
                              },
                              "id": "{k(U(XwPdG~h:5lc(;Qj",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "OP": "MINUS"
                                    },
                                    "id": "7tUxsaIS}XpWY!B%~:#%",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "fields": {
                                            "THIS": false,
                                            "VAR": "boardVariable:Tick"
                                          },
                                          "id": "7)kOXWK1sW=EM:gE8:_V",
                                          "type": "variables_get_reserved"
                                        },
                                        "shadow": {
                                          "fields": {
                                            "NUM": 1
                                          },
                                          "id": "O70iWAb8S^-9]7pq:A+`",
                                          "type": "math_number"
                                        }
                                      },
                                      "B": {
                                        "block": {
                                          "extraState": "<mutation></mutation>",
                                          "fields": {
                                            "TYPE": "board",
                                            "VAR": {
                                              "id": "6ji6Z$As$U=?*^_`Bmp~"
                                            }
                                          },
                                          "id": "t/8q$=!aTcBX.0If5nJh",
                                          "type": "variables_get"
                                        },
                                        "shadow": {
                                          "fields": {
                                            "NUM": 1
                                          },
                                          "id": "LS+usN:b4*JVXp@(=dCg",
                                          "type": "math_number"
                                        }
                                      }
                                    },
                                    "type": "math_arithmetic"
                                  }
                                },
                                "B": {
                                  "block": {
                                    "fields": {
                                      "NUM": 2400
                                    },
                                    "id": "]v8-gC~18-n60;m0o6Xb",
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
                          "OP": "GTE"
                        },
                        "id": "`3aho|/73N(ZPOkSbI2+",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "OP": "MINUS"
                              },
                              "id": "TMr5mDOqy*{`et*Uk`AI",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "THIS": false,
                                      "VAR": "boardVariable:Tick"
                                    },
                                    "id": "SR--NM.05}SV9%!5}]gD",
                                    "type": "variables_get_reserved"
                                  },
                                  "shadow": {
                                    "fields": {
                                      "NUM": 1
                                    },
                                    "id": "O70iWAb8S^-9]7pq:A+`",
                                    "type": "math_number"
                                  }
                                },
                                "B": {
                                  "block": {
                                    "extraState": "<mutation></mutation>",
                                    "fields": {
                                      "TYPE": "board",
                                      "VAR": {
                                        "id": "6ji6Z$As$U=?*^_`Bmp~"
                                      }
                                    },
                                    "id": "f_IaFXPFUoG{(+d4qC]x",
                                    "type": "variables_get"
                                  },
                                  "shadow": {
                                    "fields": {
                                      "NUM": 1
                                    },
                                    "id": "LS+usN:b4*JVXp@(=dCg",
                                    "type": "math_number"
                                  }
                                }
                              },
                              "type": "math_arithmetic"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "NUM": 9999
                              },
                              "id": "NahLMFR:g=N:g8tEz/@/",
                              "type": "math_number"
                            }
                          }
                        },
                        "type": "logic_compare"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "id": "Za50;*gMo;AUSH8!oWT*",
                      "inputs": {
                        "DO0": {
                          "block": {
                            "id": "I5W@mo.i9?+-6)zaMY]r",
                            "inputs": {
                              "DO0": {
                                "block": {
                                  "id": "!w|r)u|as9Z6c-*FhC@p",
                                  "inputs": {
                                    "DO0": {
                                      "block": {
                                        "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                        "fields": {
                                          "NAME": "boardMethod:AddUnit",
                                          "THIS": true
                                        },
                                        "id": "TxTq=y?BI5/KZU,l6Zk!",
                                        "inputs": {
                                          "ARG0": {
                                            "block": {
                                              "extraState": "<mutation></mutation>",
                                              "fields": {
                                                "TYPE": "board",
                                                "VAR": {
                                                  "id": "1ZxWa$PmVjUk0t$,8x~S"
                                                }
                                              },
                                              "id": "s0Iqw{rN?%[*jMr:,MNZ",
                                              "type": "variables_get"
                                            }
                                          },
                                          "ARG2": {
                                            "block": {
                                              "fields": {
                                                "OP": "ADD"
                                              },
                                              "id": "2rOk-O_nZPP5A;a8B|dv",
                                              "inputs": {
                                                "A": {
                                                  "block": {
                                                    "extraState": "<mutation></mutation>",
                                                    "fields": {
                                                      "TYPE": "board",
                                                      "VAR": {
                                                        "id": "y%%l?*_%JXp)m~Jd[vzT"
                                                      }
                                                    },
                                                    "id": "/;XO4o!kFfLq%[cawkOT",
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
                                                    "fields": {
                                                      "OP": "ADD"
                                                    },
                                                    "id": "-ZsMg_VIIhr8N^Ee]fxT",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "extraState": "<mutation></mutation>",
                                                          "fields": {
                                                            "TYPE": "board",
                                                            "VAR": {
                                                              "id": "@qS80$GZMo@v]=FG(Z#]"
                                                            }
                                                          },
                                                          "id": "afq.;vkKxT@aT6AUwFW2",
                                                          "type": "variables_get"
                                                        },
                                                        "shadow": {
                                                          "fields": {
                                                            "NUM": 1
                                                          },
                                                          "id": ":lSZLtqdeq3).g3NNN]b",
                                                          "type": "math_number"
                                                        }
                                                      },
                                                      "B": {
                                                        "block": {
                                                          "fields": {
                                                            "OP": "MULTIPLY"
                                                          },
                                                          "id": ".aI5KaW_gG4J8Ksmam[u",
                                                          "inputs": {
                                                            "A": {
                                                              "block": {
                                                                "fields": {
                                                                  "OP": "ADD"
                                                                },
                                                                "id": "9_@|f1eNYRNP|X`]`6%O",
                                                                "inputs": {
                                                                  "A": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "THIS": false,
                                                                        "VAR": "unitVariable:VelocityX"
                                                                      },
                                                                      "id": "hb[muJ(E!K#3Xr5qp;^,",
                                                                      "type": "variables_get_reserved"
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
                                                                      "fields": {
                                                                        "NUM": 1.5
                                                                      },
                                                                      "id": "q%!-F-1]+ySyn!haGfmo",
                                                                      "type": "math_number"
                                                                    },
                                                                    "shadow": {
                                                                      "fields": {
                                                                        "NUM": 1
                                                                      },
                                                                      "id": "YL49n]P!_LlaD:})]nZh",
                                                                      "type": "math_number"
                                                                    }
                                                                  }
                                                                },
                                                                "type": "math_arithmetic"
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
                                                                "fields": {
                                                                  "NUM": 2
                                                                },
                                                                "id": "U7YF7fUE^(K[O)X:M7R`",
                                                                "type": "math_number"
                                                              },
                                                              "shadow": {
                                                                "fields": {
                                                                  "NUM": 1
                                                                },
                                                                "id": "YL49n]P!_LlaD:})]nZh",
                                                                "type": "math_number"
                                                              }
                                                            }
                                                          },
                                                          "type": "math_arithmetic"
                                                        },
                                                        "shadow": {
                                                          "fields": {
                                                            "NUM": 1
                                                          },
                                                          "id": "@-Z-!F0Qf^F:c%#4M7y{",
                                                          "type": "math_number"
                                                        }
                                                      }
                                                    },
                                                    "type": "math_arithmetic"
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
                                              "id": "3teGxlb7ce!B`]D7Rp9=",
                                              "type": "math_number"
                                            }
                                          },
                                          "ARG5": {
                                            "block": {
                                              "fields": {
                                                "VAR": "Enemy"
                                              },
                                              "id": "2?)r/0KR#[VWpOmg`Z($",
                                              "type": "teamtag_get"
                                            }
                                          },
                                          "ARG6": {
                                            "block": {
                                              "fields": {
                                                "NUM": 1
                                              },
                                              "id": "u?v$z074s+3.qpX.Hy$]",
                                              "type": "math_number"
                                            }
                                          }
                                        },
                                        "type": "function_call"
                                      }
                                    },
                                    "IF0": {
                                      "block": {
                                        "fields": {
                                          "OP": "EQ"
                                        },
                                        "id": "o*u;.sp~(%(n#Ne5F$z-",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "id": ";B,86;ve)1Tp6BgfpiW-",
                                              "inputs": {
                                                "DIVIDEND": {
                                                  "block": {
                                                    "fields": {
                                                      "OP": "MINUS"
                                                    },
                                                    "id": ")=l.kOwzqj%Y;?In1+aa",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "fields": {
                                                            "THIS": false,
                                                            "VAR": "boardVariable:Tick"
                                                          },
                                                          "id": "d:!PHi+*ed2.6%T=hvWx",
                                                          "type": "variables_get_reserved"
                                                        },
                                                        "shadow": {
                                                          "fields": {
                                                            "NUM": 1
                                                          },
                                                          "id": "O70iWAb8S^-9]7pq:A+`",
                                                          "type": "math_number"
                                                        }
                                                      },
                                                      "B": {
                                                        "block": {
                                                          "extraState": "<mutation></mutation>",
                                                          "fields": {
                                                            "TYPE": "board",
                                                            "VAR": {
                                                              "id": "6ji6Z$As$U=?*^_`Bmp~"
                                                            }
                                                          },
                                                          "id": "8VdSvJO]IS60?b@!9u)%",
                                                          "type": "variables_get"
                                                        },
                                                        "shadow": {
                                                          "fields": {
                                                            "NUM": 1
                                                          },
                                                          "id": "LS+usN:b4*JVXp@(=dCg",
                                                          "type": "math_number"
                                                        }
                                                      }
                                                    },
                                                    "type": "math_arithmetic"
                                                  },
                                                  "shadow": {
                                                    "fields": {
                                                      "NUM": 64
                                                    },
                                                    "id": "@b2dBX(r~i_RqQDD184k",
                                                    "type": "math_number"
                                                  }
                                                },
                                                "DIVISOR": {
                                                  "shadow": {
                                                    "fields": {
                                                      "NUM": 525
                                                    },
                                                    "id": "ChV`4La`kGXhQ^wZgT-a",
                                                    "type": "math_number"
                                                  }
                                                }
                                              },
                                              "type": "math_modulo"
                                            }
                                          },
                                          "B": {
                                            "block": {
                                              "fields": {
                                                "NUM": 330
                                              },
                                              "id": "6!vk^V#S9Jx.j=WoRz+}",
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
                                    "OP": "LTE"
                                  },
                                  "id": "E/@7{[m8!SS}*l~fW3ks",
                                  "inputs": {
                                    "A": {
                                      "block": {
                                        "fields": {
                                          "OP": "MINUS"
                                        },
                                        "id": "7OuTRPJ0{JL/uK^k5OZM",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "THIS": false,
                                                "VAR": "boardVariable:Tick"
                                              },
                                              "id": "H`2-E7Gifob*kOf3w{8:",
                                              "type": "variables_get_reserved"
                                            },
                                            "shadow": {
                                              "fields": {
                                                "NUM": 1
                                              },
                                              "id": "O70iWAb8S^-9]7pq:A+`",
                                              "type": "math_number"
                                            }
                                          },
                                          "B": {
                                            "block": {
                                              "extraState": "<mutation></mutation>",
                                              "fields": {
                                                "TYPE": "board",
                                                "VAR": {
                                                  "id": "6ji6Z$As$U=?*^_`Bmp~"
                                                }
                                              },
                                              "id": "qS+b~cR46=J/WtQgGJ+r",
                                              "type": "variables_get"
                                            },
                                            "shadow": {
                                              "fields": {
                                                "NUM": 1
                                              },
                                              "id": "LS+usN:b4*JVXp@(=dCg",
                                              "type": "math_number"
                                            }
                                          }
                                        },
                                        "type": "math_arithmetic"
                                      }
                                    },
                                    "B": {
                                      "block": {
                                        "fields": {
                                          "NUM": 2400
                                        },
                                        "id": "P8W^#7ZE/N|~=SQOxRgF",
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
                              "OP": "GTE"
                            },
                            "id": "wU=5V3Pp]U~ZY_t0LNVE",
                            "inputs": {
                              "A": {
                                "block": {
                                  "fields": {
                                    "OP": "MINUS"
                                  },
                                  "id": "3*pC;@|KyjX{+o}w)TI5",
                                  "inputs": {
                                    "A": {
                                      "block": {
                                        "fields": {
                                          "THIS": false,
                                          "VAR": "boardVariable:Tick"
                                        },
                                        "id": "s!9W.pt1VW|e?IK4lhjV",
                                        "type": "variables_get_reserved"
                                      },
                                      "shadow": {
                                        "fields": {
                                          "NUM": 1
                                        },
                                        "id": "O70iWAb8S^-9]7pq:A+`",
                                        "type": "math_number"
                                      }
                                    },
                                    "B": {
                                      "block": {
                                        "extraState": "<mutation></mutation>",
                                        "fields": {
                                          "TYPE": "board",
                                          "VAR": {
                                            "id": "6ji6Z$As$U=?*^_`Bmp~"
                                          }
                                        },
                                        "id": "sw*VJ9W9J7d[c/gcN9ui",
                                        "type": "variables_get"
                                      },
                                      "shadow": {
                                        "fields": {
                                          "NUM": 1
                                        },
                                        "id": "LS+usN:b4*JVXp@(=dCg",
                                        "type": "math_number"
                                      }
                                    }
                                  },
                                  "type": "math_arithmetic"
                                }
                              },
                              "B": {
                                "block": {
                                  "fields": {
                                    "NUM": 330
                                  },
                                  "id": "pyoK)(~`-(KL:/yHC`$w",
                                  "type": "math_number"
                                }
                              }
                            },
                            "type": "logic_compare"
                          }
                        }
                      },
                      "next": {
                        "block": {
                          "id": "5s{V[IZ.o#_D=oq0cA5{",
                          "inputs": {
                            "DO0": {
                              "block": {
                                "id": "b8U,gu+;Yk83,pwH9G0E",
                                "inputs": {
                                  "DO0": {
                                    "block": {
                                      "id": "}-zGL8/RiYV2$w:{1h=,",
                                      "inputs": {
                                        "DO0": {
                                          "block": {
                                            "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                            "fields": {
                                              "NAME": "boardMethod:AddUnit",
                                              "THIS": true
                                            },
                                            "id": "2XHSN/Xwv$l+A[Kzw@X#",
                                            "inputs": {
                                              "ARG0": {
                                                "block": {
                                                  "extraState": "<mutation></mutation>",
                                                  "fields": {
                                                    "TYPE": "board",
                                                    "VAR": {
                                                      "id": "1ZxWa$PmVjUk0t$,8x~S"
                                                    }
                                                  },
                                                  "id": "Dz2paK:HU!5S%,/foh_w",
                                                  "type": "variables_get"
                                                }
                                              },
                                              "ARG2": {
                                                "block": {
                                                  "fields": {
                                                    "OP": "ADD"
                                                  },
                                                  "id": "wM2s1BmU7=7IT/mgW|5m",
                                                  "inputs": {
                                                    "A": {
                                                      "block": {
                                                        "extraState": "<mutation></mutation>",
                                                        "fields": {
                                                          "TYPE": "board",
                                                          "VAR": {
                                                            "id": "y%%l?*_%JXp)m~Jd[vzT"
                                                          }
                                                        },
                                                        "id": "ClKH_2kut|w$*58E)/.R",
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
                                                        "fields": {
                                                          "OP": "ADD"
                                                        },
                                                        "id": "MD?-:*LrSzjD,I9*-6a5",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "extraState": "<mutation></mutation>",
                                                              "fields": {
                                                                "TYPE": "board",
                                                                "VAR": {
                                                                  "id": "@qS80$GZMo@v]=FG(Z#]"
                                                                }
                                                              },
                                                              "id": "aW:Q-a)4(9hV@kQlnP!j",
                                                              "type": "variables_get"
                                                            },
                                                            "shadow": {
                                                              "fields": {
                                                                "NUM": 1
                                                              },
                                                              "id": ":lSZLtqdeq3).g3NNN]b",
                                                              "type": "math_number"
                                                            }
                                                          },
                                                          "B": {
                                                            "block": {
                                                              "fields": {
                                                                "OP": "MULTIPLY"
                                                              },
                                                              "id": ",OrF:CLcOFYgpc9WPm+~",
                                                              "inputs": {
                                                                "A": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "OP": "ADD"
                                                                    },
                                                                    "id": "ov}Q:w[TfX780JHkH$Ih",
                                                                    "inputs": {
                                                                      "A": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "THIS": false,
                                                                            "VAR": "unitVariable:VelocityX"
                                                                          },
                                                                          "id": ".9nJSuIw-05%8tRSz^QB",
                                                                          "type": "variables_get_reserved"
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
                                                                          "fields": {
                                                                            "NUM": 1.5
                                                                          },
                                                                          "id": "=FZTvfSP:UkT?eSJMLAe",
                                                                          "type": "math_number"
                                                                        },
                                                                        "shadow": {
                                                                          "fields": {
                                                                            "NUM": 1
                                                                          },
                                                                          "id": "YL49n]P!_LlaD:})]nZh",
                                                                          "type": "math_number"
                                                                        }
                                                                      }
                                                                    },
                                                                    "type": "math_arithmetic"
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
                                                                    "fields": {
                                                                      "NUM": 2
                                                                    },
                                                                    "id": "mL`lZ{*^gC-YTO_dF-1,",
                                                                    "type": "math_number"
                                                                  },
                                                                  "shadow": {
                                                                    "fields": {
                                                                      "NUM": 1
                                                                    },
                                                                    "id": "YL49n]P!_LlaD:})]nZh",
                                                                    "type": "math_number"
                                                                  }
                                                                }
                                                              },
                                                              "type": "math_arithmetic"
                                                            },
                                                            "shadow": {
                                                              "fields": {
                                                                "NUM": 1
                                                              },
                                                              "id": "@-Z-!F0Qf^F:c%#4M7y{",
                                                              "type": "math_number"
                                                            }
                                                          }
                                                        },
                                                        "type": "math_arithmetic"
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
                                                  "id": "H[@sJ=Ao+yn$?7}+{dS6",
                                                  "type": "math_number"
                                                }
                                              },
                                              "ARG5": {
                                                "block": {
                                                  "fields": {
                                                    "VAR": "Enemy"
                                                  },
                                                  "id": "yV3vsj76xLm:NqFbxZ)w",
                                                  "type": "teamtag_get"
                                                }
                                              },
                                              "ARG6": {
                                                "block": {
                                                  "fields": {
                                                    "NUM": 1
                                                  },
                                                  "id": ";u`|arz$z8-HoL`Xw0GN",
                                                  "type": "math_number"
                                                }
                                              }
                                            },
                                            "type": "function_call"
                                          }
                                        },
                                        "IF0": {
                                          "block": {
                                            "fields": {
                                              "OP": "EQ"
                                            },
                                            "id": "Ra^`2w_*O;+p#,w|5=iI",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "id": "IR@r`Gp}oaW5;GjKIgFA",
                                                  "inputs": {
                                                    "DIVIDEND": {
                                                      "block": {
                                                        "fields": {
                                                          "OP": "MINUS"
                                                        },
                                                        "id": "tu!Ym.tY7mb%~2,vxFo(",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "fields": {
                                                                "THIS": false,
                                                                "VAR": "boardVariable:Tick"
                                                              },
                                                              "id": "?]K:x!i#d{}i4$w.G[yi",
                                                              "type": "variables_get_reserved"
                                                            },
                                                            "shadow": {
                                                              "fields": {
                                                                "NUM": 1
                                                              },
                                                              "id": "O70iWAb8S^-9]7pq:A+`",
                                                              "type": "math_number"
                                                            }
                                                          },
                                                          "B": {
                                                            "block": {
                                                              "extraState": "<mutation></mutation>",
                                                              "fields": {
                                                                "TYPE": "board",
                                                                "VAR": {
                                                                  "id": "6ji6Z$As$U=?*^_`Bmp~"
                                                                }
                                                              },
                                                              "id": "ELnJvPNLi7]pARu`=k^e",
                                                              "type": "variables_get"
                                                            },
                                                            "shadow": {
                                                              "fields": {
                                                                "NUM": 1
                                                              },
                                                              "id": "LS+usN:b4*JVXp@(=dCg",
                                                              "type": "math_number"
                                                            }
                                                          }
                                                        },
                                                        "type": "math_arithmetic"
                                                      },
                                                      "shadow": {
                                                        "fields": {
                                                          "NUM": 64
                                                        },
                                                        "id": "@b2dBX(r~i_RqQDD184k",
                                                        "type": "math_number"
                                                      }
                                                    },
                                                    "DIVISOR": {
                                                      "shadow": {
                                                        "fields": {
                                                          "NUM": 210
                                                        },
                                                        "id": ",3]L=Ra*bWP-P:eh{Pio",
                                                        "type": "math_number"
                                                      }
                                                    }
                                                  },
                                                  "type": "math_modulo"
                                                }
                                              },
                                              "B": {
                                                "block": {
                                                  "fields": {
                                                    "NUM": 30
                                                  },
                                                  "id": "-l6pV;YGGnNK=/uhj9+q",
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
                                        "OP": "LTE"
                                      },
                                      "id": "9-yX,+y@=)bGMah8yxw{",
                                      "inputs": {
                                        "A": {
                                          "block": {
                                            "fields": {
                                              "OP": "MINUS"
                                            },
                                            "id": "XI?)=m5nDE=-80Jy[Y6x",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "fields": {
                                                    "THIS": false,
                                                    "VAR": "boardVariable:Tick"
                                                  },
                                                  "id": "c^X:abM!bu6]?lQ2[~C,",
                                                  "type": "variables_get_reserved"
                                                },
                                                "shadow": {
                                                  "fields": {
                                                    "NUM": 1
                                                  },
                                                  "id": "O70iWAb8S^-9]7pq:A+`",
                                                  "type": "math_number"
                                                }
                                              },
                                              "B": {
                                                "block": {
                                                  "extraState": "<mutation></mutation>",
                                                  "fields": {
                                                    "TYPE": "board",
                                                    "VAR": {
                                                      "id": "6ji6Z$As$U=?*^_`Bmp~"
                                                    }
                                                  },
                                                  "id": "i:Ktx_PeDDDhUik@mGVM",
                                                  "type": "variables_get"
                                                },
                                                "shadow": {
                                                  "fields": {
                                                    "NUM": 1
                                                  },
                                                  "id": "LS+usN:b4*JVXp@(=dCg",
                                                  "type": "math_number"
                                                }
                                              }
                                            },
                                            "type": "math_arithmetic"
                                          }
                                        },
                                        "B": {
                                          "block": {
                                            "fields": {
                                              "NUM": 2400
                                            },
                                            "id": "ner[2k^83tR|y`SD`Tch",
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
                                  "OP": "GTE"
                                },
                                "id": "_,p.|Rccy2@sf$2/b1jB",
                                "inputs": {
                                  "A": {
                                    "block": {
                                      "fields": {
                                        "OP": "MINUS"
                                      },
                                      "id": "cUAitJmPH`dsd1g6j{1E",
                                      "inputs": {
                                        "A": {
                                          "block": {
                                            "fields": {
                                              "THIS": false,
                                              "VAR": "boardVariable:Tick"
                                            },
                                            "id": "S,q^AGM-nI7Vj8-S{61j",
                                            "type": "variables_get_reserved"
                                          },
                                          "shadow": {
                                            "fields": {
                                              "NUM": 1
                                            },
                                            "id": "O70iWAb8S^-9]7pq:A+`",
                                            "type": "math_number"
                                          }
                                        },
                                        "B": {
                                          "block": {
                                            "extraState": "<mutation></mutation>",
                                            "fields": {
                                              "TYPE": "board",
                                              "VAR": {
                                                "id": "6ji6Z$As$U=?*^_`Bmp~"
                                              }
                                            },
                                            "id": "^wY.Gdzt#uohGN$a]{Mj",
                                            "type": "variables_get"
                                          },
                                          "shadow": {
                                            "fields": {
                                              "NUM": 1
                                            },
                                            "id": "LS+usN:b4*JVXp@(=dCg",
                                            "type": "math_number"
                                          }
                                        }
                                      },
                                      "type": "math_arithmetic"
                                    }
                                  },
                                  "B": {
                                    "block": {
                                      "fields": {
                                        "NUM": 1290
                                      },
                                      "id": "JBX*A6UA6vg$89($wfji",
                                      "type": "math_number"
                                    }
                                  }
                                },
                                "type": "logic_compare"
                              }
                            }
                          },
                          "next": {
                            "block": {
                              "id": "F_*,cB]_ou-:JVtg^|Qj",
                              "inputs": {
                                "DO0": {
                                  "block": {
                                    "id": "NLusV@a_(SVM3Jd=jujB",
                                    "inputs": {
                                      "DO0": {
                                        "block": {
                                          "id": "rT-tn6hq$,.?`.-3U5;i",
                                          "inputs": {
                                            "DO0": {
                                              "block": {
                                                "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                "fields": {
                                                  "NAME": "boardMethod:AddUnit",
                                                  "THIS": true
                                                },
                                                "id": "?}43b+6)^#`t$0@8sjX7",
                                                "inputs": {
                                                  "ARG0": {
                                                    "block": {
                                                      "extraState": "<mutation></mutation>",
                                                      "fields": {
                                                        "TYPE": "board",
                                                        "VAR": {
                                                          "id": "lb3Lgh^3uRiyQ!OJr^e*"
                                                        }
                                                      },
                                                      "id": "SV2Os:l{r(E=}_rEYCA/",
                                                      "type": "variables_get"
                                                    }
                                                  },
                                                  "ARG2": {
                                                    "block": {
                                                      "fields": {
                                                        "OP": "ADD"
                                                      },
                                                      "id": "L;H4/4`5~S{xg3$3wHp2",
                                                      "inputs": {
                                                        "A": {
                                                          "block": {
                                                            "extraState": "<mutation></mutation>",
                                                            "fields": {
                                                              "TYPE": "board",
                                                              "VAR": {
                                                                "id": "y%%l?*_%JXp)m~Jd[vzT"
                                                              }
                                                            },
                                                            "id": "Z0{wReoG#QF]WwC3^jzN",
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
                                                            "fields": {
                                                              "OP": "ADD"
                                                            },
                                                            "id": "$67]biP)/=DFPi{m8.4Z",
                                                            "inputs": {
                                                              "A": {
                                                                "block": {
                                                                  "extraState": "<mutation></mutation>",
                                                                  "fields": {
                                                                    "TYPE": "board",
                                                                    "VAR": {
                                                                      "id": "@qS80$GZMo@v]=FG(Z#]"
                                                                    }
                                                                  },
                                                                  "id": ".Q%A|+x{Oduz|258XcR,",
                                                                  "type": "variables_get"
                                                                },
                                                                "shadow": {
                                                                  "fields": {
                                                                    "NUM": 1
                                                                  },
                                                                  "id": ":lSZLtqdeq3).g3NNN]b",
                                                                  "type": "math_number"
                                                                }
                                                              },
                                                              "B": {
                                                                "block": {
                                                                  "fields": {
                                                                    "OP": "MULTIPLY"
                                                                  },
                                                                  "id": "qNsFTKxK:pJ6_r4X~eV5",
                                                                  "inputs": {
                                                                    "A": {
                                                                      "block": {
                                                                        "fields": {
                                                                          "OP": "ADD"
                                                                        },
                                                                        "id": "Dq~2Ukx;-5Bvhqy!,Rg/",
                                                                        "inputs": {
                                                                          "A": {
                                                                            "block": {
                                                                              "fields": {
                                                                                "THIS": false,
                                                                                "VAR": "unitVariable:VelocityX"
                                                                              },
                                                                              "id": "r?;iDo3?^F5e*c72ji{j",
                                                                              "type": "variables_get_reserved"
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
                                                                              "fields": {
                                                                                "NUM": 1.5
                                                                              },
                                                                              "id": "M^iJYCB4kIXa]{PQp91}",
                                                                              "type": "math_number"
                                                                            },
                                                                            "shadow": {
                                                                              "fields": {
                                                                                "NUM": 1
                                                                              },
                                                                              "id": "YL49n]P!_LlaD:})]nZh",
                                                                              "type": "math_number"
                                                                            }
                                                                          }
                                                                        },
                                                                        "type": "math_arithmetic"
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
                                                                        "fields": {
                                                                          "NUM": 2
                                                                        },
                                                                        "id": "y)8QpADjArmDpDO2sTg;",
                                                                        "type": "math_number"
                                                                      },
                                                                      "shadow": {
                                                                        "fields": {
                                                                          "NUM": 1
                                                                        },
                                                                        "id": "YL49n]P!_LlaD:})]nZh",
                                                                        "type": "math_number"
                                                                      }
                                                                    }
                                                                  },
                                                                  "type": "math_arithmetic"
                                                                },
                                                                "shadow": {
                                                                  "fields": {
                                                                    "NUM": 1
                                                                  },
                                                                  "id": "@-Z-!F0Qf^F:c%#4M7y{",
                                                                  "type": "math_number"
                                                                }
                                                              }
                                                            },
                                                            "type": "math_arithmetic"
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
                                                      "id": "(Nj=GcNP//KH9?CnVczp",
                                                      "type": "math_number"
                                                    }
                                                  },
                                                  "ARG5": {
                                                    "block": {
                                                      "fields": {
                                                        "VAR": "Enemy"
                                                      },
                                                      "id": "R#UyW)%FzUv-3}/=Ex4$",
                                                      "type": "teamtag_get"
                                                    }
                                                  },
                                                  "ARG6": {
                                                    "block": {
                                                      "fields": {
                                                        "NUM": 1
                                                      },
                                                      "id": "]v`^S5LeeI{u+my.lKb)",
                                                      "type": "math_number"
                                                    }
                                                  }
                                                },
                                                "type": "function_call"
                                              }
                                            },
                                            "IF0": {
                                              "block": {
                                                "fields": {
                                                  "OP": "EQ"
                                                },
                                                "id": "}9}NrC:2Oyx8:q6s?f$%",
                                                "inputs": {
                                                  "A": {
                                                    "block": {
                                                      "id": "airv/qRPe~M2g`wF@{y?",
                                                      "inputs": {
                                                        "DIVIDEND": {
                                                          "block": {
                                                            "fields": {
                                                              "OP": "MINUS"
                                                            },
                                                            "id": "/7m8#9e7N?Nm0{9}yFuZ",
                                                            "inputs": {
                                                              "A": {
                                                                "block": {
                                                                  "fields": {
                                                                    "THIS": false,
                                                                    "VAR": "boardVariable:Tick"
                                                                  },
                                                                  "id": "n1I^lp7)#rEgU565LVdl",
                                                                  "type": "variables_get_reserved"
                                                                },
                                                                "shadow": {
                                                                  "fields": {
                                                                    "NUM": 1
                                                                  },
                                                                  "id": "O70iWAb8S^-9]7pq:A+`",
                                                                  "type": "math_number"
                                                                }
                                                              },
                                                              "B": {
                                                                "block": {
                                                                  "extraState": "<mutation></mutation>",
                                                                  "fields": {
                                                                    "TYPE": "board",
                                                                    "VAR": {
                                                                      "id": "6ji6Z$As$U=?*^_`Bmp~"
                                                                    }
                                                                  },
                                                                  "id": "Os-[UAv%)6rf_[%v8%o^",
                                                                  "type": "variables_get"
                                                                },
                                                                "shadow": {
                                                                  "fields": {
                                                                    "NUM": 1
                                                                  },
                                                                  "id": "LS+usN:b4*JVXp@(=dCg",
                                                                  "type": "math_number"
                                                                }
                                                              }
                                                            },
                                                            "type": "math_arithmetic"
                                                          },
                                                          "shadow": {
                                                            "fields": {
                                                              "NUM": 64
                                                            },
                                                            "id": "@b2dBX(r~i_RqQDD184k",
                                                            "type": "math_number"
                                                          }
                                                        },
                                                        "DIVISOR": {
                                                          "shadow": {
                                                            "fields": {
                                                              "NUM": 210
                                                            },
                                                            "id": "Uk^N4b]_fE`5_N)eyVU,",
                                                            "type": "math_number"
                                                          }
                                                        }
                                                      },
                                                      "type": "math_modulo"
                                                    }
                                                  },
                                                  "B": {
                                                    "block": {
                                                      "fields": {
                                                        "NUM": 120
                                                      },
                                                      "id": "$ka%E42P.CxHZCHv[dX@",
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
                                            "OP": "LTE"
                                          },
                                          "id": "%~.LbP+P3LCT!Lv2Z]is",
                                          "inputs": {
                                            "A": {
                                              "block": {
                                                "fields": {
                                                  "OP": "MINUS"
                                                },
                                                "id": "-LW%`*pTer^~-w2^(2]P",
                                                "inputs": {
                                                  "A": {
                                                    "block": {
                                                      "fields": {
                                                        "THIS": false,
                                                        "VAR": "boardVariable:Tick"
                                                      },
                                                      "id": "H+%#Atn4FXT[RWOEZh1F",
                                                      "type": "variables_get_reserved"
                                                    },
                                                    "shadow": {
                                                      "fields": {
                                                        "NUM": 1
                                                      },
                                                      "id": "O70iWAb8S^-9]7pq:A+`",
                                                      "type": "math_number"
                                                    }
                                                  },
                                                  "B": {
                                                    "block": {
                                                      "extraState": "<mutation></mutation>",
                                                      "fields": {
                                                        "TYPE": "board",
                                                        "VAR": {
                                                          "id": "6ji6Z$As$U=?*^_`Bmp~"
                                                        }
                                                      },
                                                      "id": "R26};}HA}KTVqv_z*v86",
                                                      "type": "variables_get"
                                                    },
                                                    "shadow": {
                                                      "fields": {
                                                        "NUM": 1
                                                      },
                                                      "id": "LS+usN:b4*JVXp@(=dCg",
                                                      "type": "math_number"
                                                    }
                                                  }
                                                },
                                                "type": "math_arithmetic"
                                              }
                                            },
                                            "B": {
                                              "block": {
                                                "fields": {
                                                  "NUM": 2400
                                                },
                                                "id": "M:UPIfA)T{zpQX]8~0j9",
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
                                      "OP": "GTE"
                                    },
                                    "id": "xx^sH!dF8-0E=`AbptT.",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "fields": {
                                            "OP": "MINUS"
                                          },
                                          "id": "`7Gx|fL!qvznWuIpEZ:|",
                                          "inputs": {
                                            "A": {
                                              "block": {
                                                "fields": {
                                                  "THIS": false,
                                                  "VAR": "boardVariable:Tick"
                                                },
                                                "id": "1iNs#4v]#EYL#3{tazb,",
                                                "type": "variables_get_reserved"
                                              },
                                              "shadow": {
                                                "fields": {
                                                  "NUM": 1
                                                },
                                                "id": "O70iWAb8S^-9]7pq:A+`",
                                                "type": "math_number"
                                              }
                                            },
                                            "B": {
                                              "block": {
                                                "extraState": "<mutation></mutation>",
                                                "fields": {
                                                  "TYPE": "board",
                                                  "VAR": {
                                                    "id": "6ji6Z$As$U=?*^_`Bmp~"
                                                  }
                                                },
                                                "id": "V,z|s2~GN[WV_2f2o@ff",
                                                "type": "variables_get"
                                              },
                                              "shadow": {
                                                "fields": {
                                                  "NUM": 1
                                                },
                                                "id": "LS+usN:b4*JVXp@(=dCg",
                                                "type": "math_number"
                                              }
                                            }
                                          },
                                          "type": "math_arithmetic"
                                        }
                                      },
                                      "B": {
                                        "block": {
                                          "fields": {
                                            "NUM": 1170
                                          },
                                          "id": "Q/[CsHi^?36Z[gW:LsW-",
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
                          "type": "controls_if"
                        }
                      },
                      "type": "controls_if"
                    }
                  },
                  "type": "controls_if"
                }
              },
              "type": "controls_if"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "AND"
              },
              "id": "2P8N5*wR,Db])o|^C4WM",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "GTE"
                    },
                    "id": "B{kB1@ui2FIzy-I:w)u4",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "!eP)g[a]cC~||~f5TQiZ"
                            }
                          },
                          "id": ";R]9Veq]?u6U/I/l#A|_",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "YsR:0^4~ord5=Y|iS9,M",
                          "type": "math_number"
                        }
                      }
                    },
                    "type": "logic_compare"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "OP": "LTE"
                    },
                    "id": "4C_6+@M%5!:39xJt~3mT",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "!eP)g[a]cC~||~f5TQiZ"
                            }
                          },
                          "id": "-U:f}m7bMZ;IKGt1(_TE",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 3
                          },
                          "id": "iZP.q)VY?UAjW2?Wb`Ql",
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
        "x": 1195,
        "y": 1145
      },
      {
        "id": "evP|hOTBM8C@ele]WeY#",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "TYPE": "board",
                "VAR": {
                  "id": "!eP)g[a]cC~||~f5TQiZ"
                }
              },
              "id": "9kow(4fKBb}9/o~KChnk",
              "inputs": {
                "VALUE": {
                  "block": {
                    "fields": {
                      "NUM": 4
                    },
                    "id": "gwr0`JkB^|MRiCP4A5%B",
                    "type": "math_number"
                  }
                }
              },
              "next": {
                "block": {
                  "fields": {
                    "TYPE": "board",
                    "VAR": {
                      "id": "QKDIW|rJfw.bv*GNE1lw"
                    }
                  },
                  "id": "_om$Hf#7GzkTzDitdx`#",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "NUM": 1
                        },
                        "id": "Byb.#iVVb5[V=0Gh?|S/",
                        "type": "math_number"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Achievement Data Id (필수)&quot;,&quot;name&quot;:&quot;AchievementDataId&quot;},{&quot;comment&quot;:&quot;Progress (default = 1)&quot;,&quot;name&quot;:&quot;Progress&quot;},{&quot;comment&quot;:&quot;PlayerId (default = 0)&quot;,&quot;name&quot;:&quot;PlayerId&quot;}]\"></mutation>",
                      "fields": {
                        "NAME": "boardMethod:IncreaseAchievementProgress",
                        "THIS": false
                      },
                      "id": "1rtJqaXOJ{RXOd(3)r|$",
                      "inputs": {
                        "ARG0": {
                          "block": {
                            "extraState": "<mutation></mutation>",
                            "fields": {
                              "TYPE": "board",
                              "VAR": {
                                "id": ".|7b/OeIAw-{/00U?{|j"
                              }
                            },
                            "id": "6.2k_]kgC9d`}{[b-NL:",
                            "type": "variables_get"
                          }
                        },
                        "ARG1": {
                          "block": {
                            "fields": {
                              "NUM": 1
                            },
                            "id": "LdclWL_ZDnV*.Ah|%jrw",
                            "type": "math_number"
                          }
                        }
                      },
                      "next": {
                        "block": {
                          "extraState": "<mutation itemCount=\"4\" metadata=\"[{&quot;name&quot;:&quot;PlayerId&quot;},{&quot;comment&quot;:&quot;웨이브 숫자 (시작 웨이브가 1)&quot;,&quot;name&quot;:&quot;Offset&quot;},{&quot;comment&quot;:&quot;웨이브 시작 대기 시간 (초 단위)&quot;,&quot;name&quot;:&quot;Duration&quot;},{&quot;comment&quot;:&quot;이벤트 문자열 키&quot;,&quot;name&quot;:&quot;StringKey&quot;}]\"></mutation>",
                          "fields": {
                            "NAME": "boardMethod:SendWaveQueuedEvent",
                            "THIS": false
                          },
                          "id": "iX-Izql-A5x56b!~-+=J",
                          "next": {
                            "block": {
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": "o,xKeQe}t5}Q]cui@aQG"
                                }
                              },
                              "id": "bPs[B@:X;,0U|2D]eX=b",
                              "inputs": {
                                "VALUE": {
                                  "block": {
                                    "fields": {
                                      "BOOL": "FALSE"
                                    },
                                    "id": "jMv0~K(ge+JGko_.jIGF",
                                    "type": "logic_boolean"
                                  }
                                }
                              },
                              "next": {
                                "block": {
                                  "fields": {
                                    "NAME": "Map_EncounterTraitWaveEnd",
                                    "THIS": false
                                  },
                                  "id": "K)kU017[@0`f[Vnkb$@T",
                                  "type": "trigger_call"
                                }
                              },
                              "type": "variables_set"
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
              "type": "variables_set"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "AND"
              },
              "id": "@!q]aj4/b8I{`s.n=B4+",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "LTE"
                    },
                    "id": "b_5Rx;HGrF(=S0?9F1Df",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "E1`In?9*}@jfzg)MTlcV",
                          "inputs": {
                            "A": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "board",
                                  "VAR": {
                                    "id": "haV+evEyYXpN85{NOBM_"
                                  }
                                },
                                "id": "m(c{cG3e3)mFOE]z7zfk",
                                "type": "variables_get"
                              },
                              "shadow": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "O70iWAb8S^-9]7pq:A+`",
                                "type": "math_number"
                              }
                            },
                            "B": {
                              "block": {
                                "fields": {
                                  "THIS": false,
                                  "VAR": "boardVariable:Tick"
                                },
                                "id": "F$M(W9Khh*pevEK5ZWho",
                                "type": "variables_get_reserved"
                              },
                              "shadow": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "LS+usN:b4*JVXp@(=dCg",
                                "type": "math_number"
                              }
                            }
                          },
                          "type": "math_arithmetic"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 0
                          },
                          "id": "Gk]SUA9okOId1,SDC[IH",
                          "type": "math_number"
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
                    "id": "WkL`3x,J;@1CDlgU4zM[",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "!eP)g[a]cC~||~f5TQiZ"
                            }
                          },
                          "id": "5+@~fkT[ej9rg:/oyLw,",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 3
                          },
                          "id": "Vls/M`P-uH{F^]c!82{*",
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
        "x": 1185,
        "y": 3865
      },
      {
        "id": "G/F#~=mE:2L..3A98TuI",
        "inputs": {
          "DO0": {
            "block": {
              "id": "n6b^}pGP,b?yrao!ZJU@",
              "type": "return"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "NEQ"
              },
              "id": "k3y;TV]oK[mEDI7Fy@,t",
              "inputs": {
                "A": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "board",
                      "VAR": {
                        "id": "Ek:5yv3s|PF-]xi{ROQM"
                      }
                    },
                    "id": "y]Fq-s9igOvuu2;DIRE|",
                    "type": "variables_get"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "NUM": 1
                    },
                    "id": "TT+{(Tdpnx{AKZlp}:s%",
                    "type": "math_number"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": 1195,
        "y": 385
      },
      {
        "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
        "fields": {
          "NAME": "boardMethod:GetMainPlayerUnit",
          "THIS": false
        },
        "id": "@47GicAcNnZG-1`J?[.*",
        "next": {
          "block": {
            "id": "]Gm!MCLDK);`*AAyHMmv",
            "inputs": {
              "DO0": {
                "block": {
                  "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Duration (필수)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "boardMethod:StartTimer",
                    "THIS": false
                  },
                  "id": "LN/ir{kB)(pv,NuMbAL{",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "fields": {
                          "NUM": 1
                        },
                        "id": "4HAOsXwBy)5hAS{j$}5F",
                        "type": "math_number"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "fields": {
                        "TYPE": "board",
                        "VAR": {
                          "id": "!eP)g[a]cC~||~f5TQiZ"
                        }
                      },
                      "id": "Qw9A!Y~[CRlLFx5T2wOh",
                      "inputs": {
                        "VALUE": {
                          "block": {
                            "fields": {
                              "NUM": 2
                            },
                            "id": "U;?(8#p2+}ulU:qc4*_@",
                            "type": "math_number"
                          }
                        }
                      },
                      "next": {
                        "block": {
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "?4,(tFHY[rrPt/GzpTj)"
                            }
                          },
                          "id": "z9$W^Fo63r6YD)Y;q-!3",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "NUM": 0
                                },
                                "id": "C$UaDbFbv`fCj|eMfO`O",
                                "type": "math_number"
                              }
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
                  "id": "oe6[ixt:K/;enV8ZLT{-",
                  "inputs": {
                    "A": {
                      "block": {
                        "fields": {
                          "OP": "AND"
                        },
                        "id": "Jh0K:7!A(n[QhZ.bqA#v",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "THIS": false,
                                "VAR": "unitVariable:HasTarget"
                              },
                              "id": "K*pBcjFQi7fJN@|A9U%8",
                              "type": "variables_get_reserved"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "OP": "LTE"
                              },
                              "id": "HyN;^$0Q^IgQ%y*nzp(~",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "THIS": false,
                                      "VAR": "unitVariable:TargetDistance"
                                    },
                                    "id": "8T|Ktd6l4;3HQO4cCm--",
                                    "type": "variables_get_reserved"
                                  }
                                },
                                "B": {
                                  "block": {
                                    "fields": {
                                      "OP": "ADD"
                                    },
                                    "id": "biQ?C=K^j)bQ{g?F$E0O",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "fields": {
                                            "NUM": 14
                                          },
                                          "id": "1a6vj,+W^!9PmHAYg6Fj",
                                          "type": "math_number"
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
                                          "fields": {
                                            "OP": "DIVIDE"
                                          },
                                          "id": "[8`c=7iA{NZImm$tJmSR",
                                          "inputs": {
                                            "A": {
                                              "block": {
                                                "fields": {
                                                  "THIS": false,
                                                  "VAR": "unitVariable:VelocityX"
                                                },
                                                "id": "B1pQs=O@Pn8+ej:p0WW$",
                                                "type": "variables_get_reserved"
                                              },
                                              "shadow": {
                                                "fields": {
                                                  "NUM": 1
                                                },
                                                "id": "J*S2*s.D|#uXRZ)}N#n4",
                                                "type": "math_number"
                                              }
                                            },
                                            "B": {
                                              "block": {
                                                "fields": {
                                                  "NUM": 2
                                                },
                                                "id": "Y0l|y1o*QW7Fh#-cfhJ*",
                                                "type": "math_number"
                                              },
                                              "shadow": {
                                                "fields": {
                                                  "NUM": 1
                                                },
                                                "id": "YL49n]P!_LlaD:})]nZh",
                                                "type": "math_number"
                                              }
                                            }
                                          },
                                          "type": "math_arithmetic"
                                        },
                                        "shadow": {
                                          "fields": {
                                            "NUM": 1
                                          },
                                          "id": "YL49n]P!_LlaD:})]nZh",
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
                          }
                        },
                        "type": "logic_operation"
                      }
                    },
                    "B": {
                      "block": {
                        "fields": {
                          "OP": "EQ"
                        },
                        "id": "^clz=@=0%jHi4:JfaxaL",
                        "inputs": {
                          "A": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": "!eP)g[a]cC~||~f5TQiZ"
                                }
                              },
                              "id": "XR?|}rUL#J6$GBZ/?8jg",
                              "type": "variables_get"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "hhco8p%9KkqZbs2J$.{f",
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
            "next": {
              "block": {
                "id": "]2%j%G@Fc7-UXPI=tnXj",
                "inputs": {
                  "DO0": {
                    "block": {
                      "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                      "fields": {
                        "NAME": "boardMethod:UnBlockSkillAction",
                        "THIS": false
                      },
                      "id": "R[([`hk@6_A`?)N]wI1~",
                      "next": {
                        "block": {
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "!eP)g[a]cC~||~f5TQiZ"
                            }
                          },
                          "id": "b1,.=OUI#!9[w]}|-.Ic",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "NUM": 3
                                },
                                "id": "FniFNk]4s:4!KA/[oOez",
                                "type": "math_number"
                              }
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
                      "id": "-[n(!HQ32O8ff9{z+t}/",
                      "inputs": {
                        "A": {
                          "block": {
                            "fields": {
                              "OP": "LTE"
                            },
                            "id": "S:[wtiXtK$m=kh/*S:%:",
                            "inputs": {
                              "A": {
                                "block": {
                                  "fields": {
                                    "THIS": false,
                                    "VAR": "boardVariable:Timer"
                                  },
                                  "id": "_=bl6CI:nkZ)(Ip[4+~2",
                                  "type": "variables_get_reserved"
                                }
                              },
                              "B": {
                                "block": {
                                  "fields": {
                                    "NUM": 0
                                  },
                                  "id": "$fOIylh1x4F|1qk$qI!m",
                                  "type": "math_number"
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
                            "id": "SgHr9:Qob{1p]xaeoU**",
                            "inputs": {
                              "A": {
                                "block": {
                                  "extraState": "<mutation></mutation>",
                                  "fields": {
                                    "TYPE": "board",
                                    "VAR": {
                                      "id": "!eP)g[a]cC~||~f5TQiZ"
                                    }
                                  },
                                  "id": "6)giFI5/ECb5u=|/J/H|",
                                  "type": "variables_get"
                                }
                              },
                              "B": {
                                "block": {
                                  "fields": {
                                    "NUM": 2
                                  },
                                  "id": "I/O3qMlb@(s7W90QA;sa",
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
            "type": "controls_if"
          }
        },
        "type": "function_call",
        "x": 1195,
        "y": 575
      },
      {
        "id": "#y*|X1AWA!Zkn25z~W$o",
        "inputs": {
          "DO0": {
            "block": {
              "id": "iaBm{[b7#?1+P9-9kFXu",
              "inputs": {
                "DO0": {
                  "block": {
                    "fields": {
                      "TYPE": "board",
                      "VAR": {
                        "id": "!eP)g[a]cC~||~f5TQiZ"
                      }
                    },
                    "id": "5jn$rw(ARKpafT?SJgck",
                    "inputs": {
                      "VALUE": {
                        "block": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "$1PoXPL{qfGBjomBmn|Q",
                          "type": "math_number"
                        }
                      }
                    },
                    "type": "variables_set"
                  }
                },
                "IF0": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "C{qI{B{?Q!ksXtSAXe/1",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "!eP)g[a]cC~||~f5TQiZ"
                            }
                          },
                          "id": "-8!db:3pGfUH(q-S5[,F",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 0
                          },
                          "id": "5^T4cyfZ#$d}`zP$1%`_",
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
                "OP": "AND"
              },
              "id": "qY]2)e,!1N;j0HEsAQ|F",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "LTE"
                    },
                    "id": "~E)!w`rk6dLy2.f~XJr.",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "THIS": false,
                            "VAR": "boardVariable:Timer"
                          },
                          "id": "ZE(Q7+pLjC(f`:2hWq4i",
                          "type": "variables_get_reserved"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 0
                          },
                          "id": "L3;{_N80%J5Q.pw}:/Qb",
                          "type": "math_number"
                        }
                      }
                    },
                    "type": "logic_compare"
                  }
                },
                "B": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "board",
                      "VAR": {
                        "id": "o,xKeQe}t5}Q]cui@aQG"
                      }
                    },
                    "id": "n|JqcW#Ap?nT?pV9*!+%",
                    "type": "variables_get"
                  }
                }
              },
              "type": "logic_operation"
            }
          }
        },
        "type": "controls_if",
        "x": 1185,
        "y": 155
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Map_Default3_Wave1",
    "period": "15",
    "triggerType": "1"
  },
  "scroll": {},
  "variables": [
    {
      "id": "17iZ,RFcmp+]62]GSB{|",
      "name": "Unit/Attack_Combo_Count"
    },
    {
      "id": "XxQA3~AqtNNftU=g{{i9",
      "name": "Unit/Attack_Combo_Last_Used_Tick"
    },
    {
      "id": "qIJyGCwa35,fu/[zX/^T",
      "name": "Unit/Tick"
    },
    {
      "id": "ExrI[$k~3:=~FB=Lr:]?",
      "name": "Map/IsClear"
    },
    {
      "id": "]u]kOaY3di=:%-/O];kA",
      "name": "Map/CurrentKillCount"
    },
    {
      "id": "{3f{M(~=@{l{G2v$+EpC",
      "name": "Map/WaveCount"
    },
    {
      "id": "z)yxQeEWT^SXZ.ll$bde",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "o,xKeQe}t5}Q]cui@aQG",
      "name": "Map/IsSpawn"
    },
    {
      "id": "Udr_a%Rg;e@Jc14#pj.t",
      "name": "Unit/CurrentWeapon"
    },
    {
      "id": "7z!g[`iC@p!9b9PzmaEG",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "P-bcuIFjK!Jbi]1EkDfR",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "!bFYK#3-mWki(zMFHUf6",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "ao+rPO#~ZI6oP/dj;nwR",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "EC:VnrcCyt`a[PcJq[fv",
      "name": "@Unit/AttackRang"
    },
    {
      "id": "_q+1_e4LWxPoO|1NDp=,",
      "name": "@Unit/AttackRange"
    },
    {
      "id": "NkJKp-nA.!oTk`[R#?Ez",
      "name": "Unit/AttackRange"
    },
    {
      "id": "D;$eiWy1~h^z9a:Hbiuc",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "]Vo,n3Nn8+Hr@+U#jqu4",
      "name": "Map/TargetKillCount"
    },
    {
      "id": "]q@xwJtiAL4PeN)N79s]",
      "name": "@Map/TargetKillCount"
    },
    {
      "id": "m_d^|T8P7r!|)3~dZ?nW",
      "name": "Unit/SkillTick"
    },
    {
      "id": "zrp7QE%H#?KW{C8ae?Mn",
      "name": "Unit/IsSkillUse"
    },
    {
      "id": "?gu$n;ME(99uY@QDAgJW",
      "name": "Unit/IsSkillUse_002"
    },
    {
      "id": "3q@0[kL_;MCv3QF+-|om",
      "name": "Unit/SkillTick_002"
    },
    {
      "id": "jrZo5EMOYVTQhK|D$GBT",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "2?r#U3llXf61Qdu}ep(*",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "Iu||gZR*TV/x@N51JXq9",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "~hVv5|FP8(M_}?*FEp@i",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "mRUnvFDHciwU9~MvuL[T",
      "name": "Unit/Counter"
    },
    {
      "id": "P]0OxWgbvi;#!X![xCPm",
      "name": "Unit/IsSkillUse_003"
    },
    {
      "id": "8z~E#TLMIePH[Y9R@hrW",
      "name": "Unit/Time01"
    },
    {
      "id": "~C)pHPdrT_h~sFEO4q+M",
      "name": "Unit/Time02"
    },
    {
      "id": "cDA:|eq-n}prcs1VBDaZ",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "dK]0ctj@l=#rV#b^ozoN",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "(PxoBY4isW`L2MYTtOnL",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "f|wUD@5ldx`}:QS!?^KP",
      "name": "Unit/Rome"
    },
    {
      "id": "8SKmvBIM{nj-#V~sKgtU",
      "name": "@Unit/Delay"
    },
    {
      "id": ",M_1Dg(lTKsRfrBQ3/hP",
      "name": "@Unit/Range01"
    },
    {
      "id": "8F]ufWf]]i8}X^X61)qk",
      "name": "@Unit/Range02"
    },
    {
      "id": "AW+32ElImuVbl(Ih0ZRE",
      "name": "@Unit/Range03"
    },
    {
      "id": "g3j+-N/}HMIB05)9Xmly",
      "name": "@Unit/Range04"
    },
    {
      "id": "?8%_FjohttQi/Fa@80=:",
      "name": "@Unit/Range05"
    },
    {
      "id": "bl1Q{y1-pXZFdq|o*a$1",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "%%Rd4}R@D18r.G!dk.`J",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "Q$5h1Xr-t$dfyj=gJIT.",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "0f$8t:5G6g)|,{%+F)?I",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "U:DgofL:VUmZ}SrWeSJW",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "!S+9l.%c?T$2RboY?d`1",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "i3GoyOXM:iF[/!y9$p3@",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "{oub/Tv?Yhibj;kv:T`[",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "4jGE!Q-5il#d:?%gqFD]",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "UVKZi@=EB5q~XfaN!0Dg",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "8s)7iDtp*?l1#Ch#gLeL",
      "name": "@Map/MonsterID01"
    },
    {
      "id": "4m.l{#?2:1m,g5,dgw*n",
      "name": "@Map/MonsterID02"
    },
    {
      "id": "rtL{PT+dHk=`)Y9|SazO",
      "name": "@Map/MonsterID03"
    },
    {
      "id": "@^*uyuHlB!mWR!PYcx^_",
      "name": "@Map/MonsterID04"
    },
    {
      "id": "PMYDWrZlh*`snSjS]?by",
      "name": "@Map/MonsterID05"
    },
    {
      "id": "4J(co3Yhz]wWrSl*Na?K",
      "name": "@Map/MonsterID06"
    },
    {
      "id": "eP3uhXXs$19Sy1e^^PiX",
      "name": "@Map/MonsterID07"
    },
    {
      "id": "BngcG.dg(Jfy=rwA;EEI",
      "name": "@Map/BattleValue"
    },
    {
      "id": "V3!I#9ZxGNJUFfqc$Uyk",
      "name": "Map/BattleValue"
    },
    {
      "id": "hrg5qh(,s]msZU8vZK}s",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "y%%l?*_%JXp)m~Jd[vzT",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "d{oJWs*w2o*c%$3^)WWI",
      "name": "@Map/MonsterID08"
    },
    {
      "id": "j#4J]=:hBqoz3e6LT(kz",
      "name": "@Map/MonsterID09"
    },
    {
      "id": "-8AxGh+asyZftQ-}8C~u",
      "name": "@Map/MonsterID10"
    },
    {
      "id": "Q(J]zCxHJCya~dNy-njH",
      "name": "@Map/MonsterID11"
    },
    {
      "id": "dt$N)BYf=3;B~@GW)Y+z",
      "name": "@Map/MonsterID12"
    },
    {
      "id": "^yfH54)h8b_*8w=if~*_",
      "name": "@Map/MonsterID13"
    },
    {
      "id": "cLt~5Fr,hJ_srU]b:22z",
      "name": "@Map/MonsterID14"
    },
    {
      "id": "0!.?Lci.s.ja-[7)Y^qV",
      "name": "@Map/MonsterID15"
    },
    {
      "id": "ykt{G4|o{AI?8^;t0AB|",
      "name": "@Map/MonsterID16"
    },
    {
      "id": "+N2NQDc!(P^xNV|7la{D",
      "name": "@Map/MonsterID17"
    },
    {
      "id": "%EjA6BC8pnQMvxi:]P^S",
      "name": "@Map/MonsterID18"
    },
    {
      "id": "vEtn:)f;v0-/2YwB4e(a",
      "name": "@Map/MonsterID19"
    },
    {
      "id": "]tAEtyK1]tol_2J84rM+",
      "name": "@Map/MonsterID20"
    },
    {
      "id": "1_d:cLOn9Hs@h3RdE/[H",
      "name": "Map/WaveTick"
    },
    {
      "id": "eFjq6%w#SFFlrYt%G4dg",
      "name": "Unit/AddInitBuffID"
    },
    {
      "id": "#td?sxB{CQclfq13aE(w",
      "name": "@Map/AddBuffID01"
    },
    {
      "id": "q)$`^EE`5}+q{H(v=T3B",
      "name": "@Map/AddBuffID02"
    },
    {
      "id": "Ftxz}xGPL+?Fp=luS@+u",
      "name": "@Map/AddBuffID03"
    },
    {
      "id": "5;cQ%iw$J7OG*NjCR2CC",
      "name": "@Map/AddBuffID04"
    },
    {
      "id": "*RY!K]mc2;`*3#kZD{r-",
      "name": "@Map/AddBuffID05"
    },
    {
      "id": "Rrh1n.ScB6c(-wRE-Da9",
      "name": "@Map/AddBuffID06"
    },
    {
      "id": "Csdn3]4AaONY!aH~@@+]",
      "name": "@Map/AddBuffID07"
    },
    {
      "id": "Wu/rv=8RjkeM%mDTFfsP",
      "name": "@Map/AddBuffID08"
    },
    {
      "id": "$luj+jif4DIqkCuv2sBp",
      "name": "@Map/AddBuffID09"
    },
    {
      "id": "pj6Y~U%-H7{y`(/m/7_w",
      "name": "@Map/AddBuffID10"
    },
    {
      "id": "u18}jZVUiXQr!vV.,K2v",
      "name": "@Map/AddBuffID11"
    },
    {
      "id": "j*t)XML;dVs$^2;8ez~p",
      "name": "@Map/AddBuffID12"
    },
    {
      "id": "@C+`jBzWvmplv)r}oMGW",
      "name": "@Map/AddBuffID13"
    },
    {
      "id": "srv*f8WX:qR@PI}%+~NO",
      "name": "@Map/AddBuffID14"
    },
    {
      "id": "Q(G2/|WKtn={4`r7S-T|",
      "name": "@Map/AddBuffID15"
    },
    {
      "id": "buARz]~}%yfb@1|h-?:F",
      "name": "@Map/AddBuffID16"
    },
    {
      "id": "J5Go$_NOwd6y*EhHFk5X",
      "name": "@Map/AddBuffID17"
    },
    {
      "id": "[TgvTos[q3+ED9Z[)Gm3",
      "name": "@Map/AddBuffID18"
    },
    {
      "id": "tKDTuBjSwo6.Wd,1s^jf",
      "name": "@Map/AddBuffID19"
    },
    {
      "id": ",LwC!,q`cDsQiAE7rCp+",
      "name": "@Map/AddBuffID20"
    },
    {
      "id": "yu+aN6guL,{M^Wmb-s|$",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "HpPMfS)`pa8c%Qhg_K[x",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": "%Lt$O5TS|.-{?}Vlr_Nx",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "3dC=x)/BsV5)k;k!h*lQ",
      "name": "@Buff/Variable/01"
    },
    {
      "id": ".UNr@xQ2CT5Nh3Q|)V_J",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "4HLpYkL6C*_oM/a[/C9[",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "~cg.IM:Rud}b7Y*sKx:o",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "C{+i]H}J4SQ@6F8-._$J",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "f{V77cT`TH[;!Utb2)(^",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "*fWEz6tDqEeJ#W!rN*_W",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "z^Ra2ja.-kZJJzH)8t%c",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "mIl^ITBpS-6kKtI/#jm,",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "j}4^-n21jRo8L]lc$x:;",
      "name": "@Map/MonsterID21"
    },
    {
      "id": "P0A#7dWwJ:2+Mx64*jES",
      "name": "@Map/MonsterID22"
    },
    {
      "id": "u_Gd*Ez{0h0F0pVTiD*%",
      "name": "@Map/MonsterID23"
    },
    {
      "id": "~CqpQhaq*KB7Mk|8pgX2",
      "name": "@Map/MonsterID24"
    },
    {
      "id": "QmPU+tM*r@M42pb$?*TL",
      "name": "@Map/MonsterID25"
    },
    {
      "id": "V9wrrI3HJ3PF}q*/Xm)Q",
      "name": "@Map/MonsterID26"
    },
    {
      "id": "@,$+1G}$fKTu!i(S%$Sb",
      "name": "@Map/MonsterID27"
    },
    {
      "id": "6)$u7C@Lf1wFm!T^`+-)",
      "name": "@Map/MonsterID28"
    },
    {
      "id": ")Kl*hV?tMESa.C3*[:U-",
      "name": "@Map/MonsterID29"
    },
    {
      "id": "2c}=*fn^}?1Iy0S#dQKc",
      "name": "@Map/MonsterID30"
    },
    {
      "id": "cV;.+{0)S-,yhho@p3hb",
      "name": "@Map/MonsterID31"
    },
    {
      "id": "K3GK9pv.z]!;Qv2ih(_h",
      "name": "@Map/MonsterID32"
    },
    {
      "id": "p]K(q;VPYs*pBTR23:5X",
      "name": "@Map/MonsterID33"
    },
    {
      "id": "#:4eEPD5!7]Jlx5F~8VG",
      "name": "@Map/MonsterID34"
    },
    {
      "id": "J(O#?^9z*U)}!9mi?WHY",
      "name": "@Map/MonsterID35"
    },
    {
      "id": "geNdQAd}:H-r_}^Z2N:#",
      "name": "@Map/MonsterID36"
    },
    {
      "id": "WPkP9D0/?AQF5mR;+M:L",
      "name": "@Map/MonsterID37"
    },
    {
      "id": "HXHjg7%T!=J]hgot]]U#",
      "name": "@Map/MonsterID38"
    },
    {
      "id": "6Tx1_`DFy(ULduyK[,V[",
      "name": "@Map/MonsterID39"
    },
    {
      "id": "`fk2f:tuV?*-b.`JtTAt",
      "name": "@Map/MonsterID40"
    },
    {
      "id": "i21[JRg%OzdUY:D_2Db*",
      "name": "@Map/MonsterID41"
    },
    {
      "id": "jA%c2.YIpNr-qkW)pFJL",
      "name": "@Map/MonsterID42"
    },
    {
      "id": "Yu[P{*m7,@9IY1OF5_zC",
      "name": "@Map/MonsterID43"
    },
    {
      "id": "sMG#to{S~U!|i@b#Sc!J",
      "name": "@Map/MonsterID44"
    },
    {
      "id": "axA1zC_(#DZ:6aBv8V%`",
      "name": "@Map/MonsterID45"
    },
    {
      "id": "mXL5Trjb8H^*^{2qc(W1",
      "name": "@Map/MonsterID46"
    },
    {
      "id": "q*D80f}%urE%f%iRi+RX",
      "name": "@Map/MonsterID47"
    },
    {
      "id": "5Y=B-RI5!#E01H{:A+Fe",
      "name": "@Map/MonsterID48"
    },
    {
      "id": ",C!=I6LTd5LD*I}I3#Gh",
      "name": "@Map/MonsterID49"
    },
    {
      "id": "7%u!**1DZ!Fj,G*xiO~6",
      "name": "@Map/MonsterID50"
    },
    {
      "id": "J@tKKX!=)Rh|NjeF^jjE",
      "name": "@Map/MonsterID51"
    },
    {
      "id": ")Y0~+sUgumuO{c~U4Xz*",
      "name": "@Map/MonsterID52"
    },
    {
      "id": "j-3PbtnbCq0Vux*K8Z/A",
      "name": "@Map/MonsterID53"
    },
    {
      "id": "`C2up;OF-8IyK9%s]4:^",
      "name": "@Map/MonsterID54"
    },
    {
      "id": "y[5N$bhsv[`/hWwcY-#o",
      "name": "@Map/MonsterID55"
    },
    {
      "id": "?F=KG-e4`qM7,~XvMk=u",
      "name": "@Map/MonsterID56"
    },
    {
      "id": "HMhRBR)]`Yv`(ijpzc7Y",
      "name": "@Map/MonsterID57"
    },
    {
      "id": "5-i3X2*l7$b|)6efWK-N",
      "name": "@Map/MonsterID58"
    },
    {
      "id": "!98^Je{+,uXL~vg|i29=",
      "name": "@Map/MonsterID59"
    },
    {
      "id": "aF`XKkZ~!*0Xpa8@G$RT",
      "name": "@Map/MonsterID60"
    },
    {
      "id": "FzM73Drmq{LL{Q9`-3+e",
      "name": "@Map/WaveID01"
    },
    {
      "id": "g%:L^AD#CxGiQi`?+IH#",
      "name": "@Map/WaveID02"
    },
    {
      "id": "AI({gn`Tt}:4|H;8A^[u",
      "name": "@Map/WaveID03"
    },
    {
      "id": "8BJ-S1hx)Hkf(WSw}MZ7",
      "name": "@Map/WaveID04"
    },
    {
      "id": "EwSA{i8xrXuxflslwV#g",
      "name": "@Map/WaveID05"
    },
    {
      "id": "5E6x]CNWjcB6dPOw{L.=",
      "name": "@Map/WaveID06"
    },
    {
      "id": "D=.5!SK}BaBz:?Wk/Y6s",
      "name": "@Map/WaveID07"
    },
    {
      "id": "T^Yj#Axk%qPi3`/NV_gb",
      "name": "@Map/WaveID08"
    },
    {
      "id": "9DS?fIjbh-$`dC(p?hrl",
      "name": "@Map/WaveID09"
    },
    {
      "id": "RDlP:1X+R{|4T`XroU:G",
      "name": "@Map/WaveID10"
    },
    {
      "id": ".|7b/OeIAw-{/00U?{|j",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "XuvHHbTtLq{rys|J[/]L",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "[#Z`WwjGGpos0i;%ZTt`",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "Qt:^WnS05jSsZZfq;,D%",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "}{iuL^x,9Xy-n)7!0#4{",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "_G?SDagd,`WS/`ksncsD",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "aiuGca|ZeJuNP]o,/Bi;",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "tfU5LSf@cuT-(PS@!bU?",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "=vGsBL5n2;.I+hV1!yE8",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "/.0{yHvR=3E)LH}BkB;y",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "1^g4waiB7iT=jn;njPsk",
      "name": "@Map/MonsterID61"
    },
    {
      "id": ")R.re-^tKu/oYkGfRfqs",
      "name": "@Map/MonsterID62"
    },
    {
      "id": ".gJ/UUJra?]a~oR~+pW=",
      "name": "@Map/MonsterID63"
    },
    {
      "id": "2@(P^yb$8.J/Br0$iJsn",
      "name": "@Map/MonsterID64"
    },
    {
      "id": "JpzMg^WnKXn.RK%542xu",
      "name": "@Map/MonsterID65"
    },
    {
      "id": "XX}cqkZg/mRo2i?bbMGP",
      "name": "@Map/MonsterID66"
    },
    {
      "id": "*{{|K_35,#P)LRoVn~:y",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "OHxH:8Q$[K#@2U7C.]YY",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "rNl0@EtmUgXW_(UZLy`p",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "E-lu`cFVH}kP19W=c+6~",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "?69g{@WN=^|CXu-FMxpe",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "l?PL|3!P6949I!hCgf6z",
      "name": "MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "lrQs%Bp{,li/!j!P;noh",
      "name": "MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "[HO*;i`Tr%]CNp~(8BJN",
      "name": "MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "k^S4!$s:atrgS-zNwv^S",
      "name": "MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "a0.~VmdXJ?Ih7zn0d%mP",
      "name": "MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "[uM#7)D`e7x1ZNJBVex`",
      "name": "MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "Uh.3Z.C0=:YnP3/$fC]1",
      "name": "MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "8G`oO-yI*Di*-v4i/yq]",
      "name": "MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "/2-2b(w`]?^dKH:Sk}Ge",
      "name": "MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": ".#I2L09dk:w(H(ns%tz:",
      "name": "MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "0I:i)D_$a=a**|]+s)sM",
      "name": "MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "H*s}RMZ{-nc.yIEj#ax8",
      "name": "MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "sE[9sM*4gR;lOwXcauki",
      "name": "MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "J*8xsF%}k)rxd%Z92q(^",
      "name": "MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "2zCC!eO%p.,R7y0y:Zhh",
      "name": "MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": "_M^c[Fp##5O8CI-j7T#:",
      "name": "MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "lU7:.[(-F.:~]1}t[;vE",
      "name": "MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "@{$-NI0lOWwA_07M3lmn",
      "name": "MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "_KR[fiA*pjQn[{/L:v,4",
      "name": "MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "j?)4h[ec![BA}@nNn18.",
      "name": "MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "cvDeqVlav;:zuatEu^tx",
      "name": "MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "[*]9};`k0.}.{`I]mzdv",
      "name": "MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "uM2WWhc:=7*Z,54#ArKi",
      "name": "MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "]M1VQ5)i94?i=fQ+F~];",
      "name": "MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": ".T=4PY}[u8i7e_1HT^*+",
      "name": "MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": ",,zX.uR2/CCLi/CFrue#",
      "name": "MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "W(Su8kO~)?Nroz?g7fx1",
      "name": "MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "e:u3Fi*qo:L2/*s!1-[g",
      "name": "MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "So%S$-FhLS??gww^}nXE",
      "name": "MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "}kpD[L!]e=drV*Jh5gvN",
      "name": "MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "z6g|1Mj@_:Y?Or/5w}NW",
      "name": "MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "qlYo9T$lv,,MM`7QaIP8",
      "name": "MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "+$[._[S?RjmLzI;Acz_q",
      "name": "MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "CbqkYThd+:UNpyX$L4K)",
      "name": "MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "S|2#q0wzrUWT;:ufC?hn",
      "name": "MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "qDJBB4)_|X]oIX@cQa3f",
      "name": "MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "?xESdr^T;cCK3u1!]gG}",
      "name": "MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "t;n^=Ipe]3;H:$M`sYL_",
      "name": "MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "DP1-)nT7}}%Gzr?hv9;2",
      "name": "MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "@yeLH@awSWhrr4fb_}e}",
      "name": "MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "l6oq`10iYI8+UQ7ypgx@",
      "name": "MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": "a+8@Z6VS!G17qXRPhct;",
      "name": "MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "AD(rv/6Ub.=[cN!9}w?!",
      "name": "MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "}U}sFsm+d5|$?V?-;+)*",
      "name": "MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "/XUvx;3AQDQ-tYKe?MZP",
      "name": "MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "]DSDHN!W;t)()Qk3EEbW",
      "name": "MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "=qg3B?u2!co_}+7il0d6",
      "name": "MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "Qapqsk(q8W@BC]OtINU}",
      "name": "MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "zQO5kH8Nd1@ENrWh,s}s",
      "name": "MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "155vd9%+Mz9t{bCw7j6~",
      "name": "MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "+R1x_bFGAM=9|EL;41M:",
      "name": "MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "o^2n~]wYy($S/r]kx0W1",
      "name": "MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": "2H73,|9R[h6ej(*,q0fw",
      "name": "MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "]=gZdHv6t6h]%D0Q3Vu.",
      "name": "MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "65(r,j:L?wq,+c;c(qe:",
      "name": "MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "Q28s9Mm+e`?W1J(/I)DL",
      "name": "MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": "n9p*`fp,DG+V*!0A8~Rd",
      "name": "MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "ttVh^0e;F)@CoA=i=Ihs",
      "name": "MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "0:+6v@rRJdQG44YOmHGO",
      "name": "MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "eQ|6qXy6|4ZtF1NG0mD*",
      "name": "MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "=~R]+{rI#;QfuC~nVrnR",
      "name": "MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "!@nN;fPi^VLKJLTmW`aA",
      "name": "MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "5{x55xmZE?i7O@W*M9bF",
      "name": "MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "b_coo]$5H.$G)W0$4fvp",
      "name": "MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "@%`SKP;L.s2JNj9a~8Aq",
      "name": "MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "$;:U@ZC~KD`f,c5Z_zbd",
      "name": "MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "sWyZj/XEFe-gjt/gEHkJ",
      "name": "MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "pi-9Z3MY[J/ep%F)|wlL",
      "name": "MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "GBOnH`,HM2/;M@AG_OOz",
      "name": "MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "BC!(kiJM]x-F4m/Iwkhb",
      "name": "MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "3F~yLv@F1+)=)p!QjN*y",
      "name": "MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "{et_ThHBfjDA[3W^?Z6A",
      "name": "MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "DB)XQ@5TMvfjJAc*]*:I",
      "name": "MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "OO.fFZ8FqM4rt;Ze^ODd",
      "name": "MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "_B4Ud.CT[rl*f/Ut!U8h",
      "name": "MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "S^]R{-Y5C*XwmP5D(ik~",
      "name": "MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "$55Hrhz;D)ycu^x7(ktj",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "%=P6Pw5JP:;nkVC8s|1~",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "_{hjZe9,oy_![{Juq-LQ",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "LE;@Jex8|Il%u$8NzzlM",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "|D/;:svqHE+t0^YEi,{7",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "GB@ceOT0[AA%e@L2~oZ)",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "u*Tz0?tfN(`l3]p-tdTE",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "mn8aZFQ)A_yUp)vx6lwR",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "7outhOIK;a`#w;?gz*8,",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "+;.}Qe9dVTx.{eHY}bkM",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "W.jw+M%jDis@;V@2GUf1",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "-e1z7yk@lXQL9nE_b1fa",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "}=6NMX$k`^htpp=Yg]@;",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "1)lP`YPMS}L#9H?:.r+9",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "_$a*2j~]:mC7MA*Ddm:Z",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": "le3jTyoQ=@%/)8|[7s:P",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "FOw?O3x-)7;lYMO2it8)",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "?a+k}$nu_3uQdTA#t_bG",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "Y;*#9i;t/r$X?py;yWV1",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": ")ykyXtWKbE238:r3]y1^",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "C[gpU!g@Y+xxE8@])]Eq",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "|CNsul!m)P00H9EWgHf}",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "UrdSpd?7wrAe8zhv#ojv",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "2{^KH2;E4s_2+L#lkk~A",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": ",bT)653^%NmWNmc9-E,j",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "UqBYO8Q[_V?j,]Jjjzcd",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "/G`UuO,,nkGVS7Zt5]#m",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": ".~=hN,5$wW1`WxD6t*K:",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "?Gsh3*qTZ`tx`{B4E^Ux",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "Uj]P_h}KB#!hAOyG.`Xp",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "Ps_iMrxu_ZA7J-.G7hAp",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "/dRJPp*cvGP#G~Zfj,wH",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "/2#VY+95]KjPnK}8o?Iv",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "y~O8kz;es7aip,Dp/=xj",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "2;$VxT@0-qoD}e^`kXNt",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "`E+PE2tu|z4x,m%BUx!m",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "e]e!4`@Gf:+cq,YTun%`",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "VkT0*^W2onOf~spTqmy[",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "@w:IZgW+f#{80N](FnDz",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "Z2xsmOXz(e-;QCl+-[a`",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "(1/k]z~5z2^bVYRA-^J[",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": "Ke2pt{W3Av8XpC4)eXpQ",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "x~5SDTq#+@E,CQgYqf3x",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "5GuWIK=^j,64v?0*.w6K",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "daAi7@OO8vqoSr;L!/oy",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "=#dv_xm^EXtpto-|mwmn",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "_5YOyx9}[w#nM2;qa8~u",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "^HzJ]I`lu[`O-]{,w/mo",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "7;q:Ps4LR+{R%8!q6Q4O",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "4@iTTk|{)5o(N@@o|0Yf",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "r]TBsB8i:8u:zW!^{8Ys",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "2n!P);y(b)#KT;mY[]}d",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": "mJx_!4~TVT}o02VKb#!D",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "^%MceJ~Rx=EL}}m[z!uJ",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "YZ{t_g|98GdBq,ybBI`6",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "PnvV`,_0!]80rFZu.8?@",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": "]K}nsS-u?hCfyO%%c=Ut",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "A0WL/93n7J-I)ZkcPdxr",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "wS,eA{N.*fRvCQoQ1_j*",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "5stvC0h?GsC`cplrN~}}",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "dov4(0c?KrhRucCyAs_v",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "|x;?GrEn5|GD(wFw]-TX",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "#bp|~TT%N5KCGskgf/:V",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "$j%@R6DQh!eGS!D!}.)}",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "i4I6VgR|;?:N8k1;y:kA",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "Ls/EF8m2Xg;6V6,QjT;.",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "eEqg-*-!CZ5-`r,?[pb3",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "oC~j6V3?/@u(fqUzf2qM",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "8)f+p05uCAsCDx];E:mU",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "tJ8CMc_E`V8w#+Uatxri",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "6e6X(j7jib3,$zW*G((b",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "JR%}wewW4QQp45MhcO(^",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "MS$:|q^*N%87(-NO;mN3",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "Ur8L6q5Gv6gMG7W/D38V",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "l:v4m?MT*6N}Hr(#SpAs",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "%XD+?6U`?o6.^aAAwAo1",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "+jxcDupoT=9qL)%(gF#b",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "^)^MhC8PWkZgY9^D@wg.",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "%vDfEbM{LDIQ3aam$t07",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "gj7L`Fh~AZFJFSO8`P|d",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "Kt0d8[KF}%U!t*GDGv`w",
      "name": "Map/WaveStartTick"
    },
    {
      "id": ";/qVS4O5P|A?|9V2^A%c",
      "name": "@Map/Encounter/Unit1ID"
    },
    {
      "id": "G^g[cWA,%}G`Lp53;hSo",
      "name": "@Map/Encounter/Unit2ID"
    },
    {
      "id": "Vi7isl_%RQlWysK_JK+R",
      "name": "@Map/Encounter/Unit3ID"
    },
    {
      "id": "WXFqQUh=p2cKQzbwRiu^",
      "name": "@Map/Encounter/Unit4ID"
    },
    {
      "id": "{wA!lK$$I9HwOs9HKSxg",
      "name": "@Map/Encounter/Unit5ID"
    },
    {
      "id": "BCLp`ZW^IRfa7rB[+nO+",
      "name": "@Map/Encounter/Unit1Percent"
    },
    {
      "id": "`wG=Lr6T5i]iNtX)_8x;",
      "name": "@Map/Encounter/Unit2Percent"
    },
    {
      "id": "0-iMf#2#P50$i~gPc.AP",
      "name": "@Map/Encounter/Unit3Percent"
    },
    {
      "id": "y3q2G9k!aiY[oe%2[?yT",
      "name": "@Map/Encounter/Unit4Percent"
    },
    {
      "id": ",dq@Gm=S*:$!F,K?XeU7",
      "name": "@Map/Encounter/Unit5Percent"
    },
    {
      "id": "@qS80$GZMo@v]=FG(Z#]",
      "name": "@Map/Variable01"
    },
    {
      "id": "sk|td^Rt8B+DI2ZpKz^~",
      "name": "@Map/Variable02"
    },
    {
      "id": "e]~,AG4KFk=y%rf|xo]9",
      "name": "@Map/Variable03"
    },
    {
      "id": "a8~dcELlL,i7E`nt%kpK",
      "name": "@Map/Variable04"
    },
    {
      "id": "CRsKuvy.F``Va}HsVhLj",
      "name": "@Map/Variable05"
    },
    {
      "id": "[y4jwYMV/GlrM;h7ycD,",
      "name": "@Unit/Variable01"
    },
    {
      "id": "0b9R[XQIDQgEFX(!w*S5",
      "name": "@Unit/Variable02"
    },
    {
      "id": "=qKBcoIS`3[!GpJ`jW.Z",
      "name": "@Unit/Variable03"
    },
    {
      "id": "}-4A[tP4DHic.x3g[*=/",
      "name": "@Unit/Variable04"
    },
    {
      "id": "g-1fE9qenN$|H5Cl9KC3",
      "name": "@Unit/Variable05"
    },
    {
      "id": "QKDIW|rJfw.bv*GNE1lw",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "1}TA{;03`dhdyQ7bhc^m",
      "name": "@Map/Encounter/Variable1"
    },
    {
      "id": "WZ-y:oer,p@Jt278Z*P|",
      "name": "@Map/Encounter/Variable2"
    },
    {
      "id": "!RMv.s8s8.QG4.H_6;M}",
      "name": "@Map/Encounter/Variable3"
    },
    {
      "id": "akh,osT0@^R~Jv1QoaVD",
      "name": "@Map/Encounter/Variable4"
    },
    {
      "id": "GZs@/U$lLq7/L4-6y,Do",
      "name": "@Map/Encounter/Variable5"
    },
    {
      "id": "iv5dy#he^kW2t@k?)%+V",
      "name": "@Skill/Trait/BlastIncreaseKBPercent"
    },
    {
      "id": "R3E]/X*NZgXxD}:i^qp8",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "=zT7LvDQvF0l5$%mo+U)",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "Ud]r}ZQ}2wXcXl!Xb9F+",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "-;.|t(_Tq.]y3Z$;2f!Y",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "1ZxWa$PmVjUk0t$,8x~S",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "lb3Lgh^3uRiyQ!OJr^e*",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "/(;L7)])x+I%LUTTX03T",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "VR|yLdFXg1hJv-Efy{2Q",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "fGadW0}UdDj^As}/@OHo",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "X^eH_2*Uonzrl(xn)x!:",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "T@O0cH?QCY4G~Y4|kIE(",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "jZ@hoA`kM$@M^)K/jNt%",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "nXr29H*chdjrTML^];DF",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "jF@letkVe]W#BC(saUtz",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "=;:}4mBau:+[`,l1|E;~",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "ycUt=6M+|y6@%NO~V#o6",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "+~3*16N`%Hc=g}Y)-NFZ",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "1}_t.kM,um9E,=?Dm)w*",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": ";cb}HfaPRr]OpbrI5+h*",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "E]cGG%ueSD+AKV!$X|CW",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "WvnT#]A-H$JKE-=f[/53",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "W.fhb|,IKG?fFAbq(xT4",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "{pWY@o*k=B!+.%S#bq^F",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "SjaH0m=gA#:,qX_XNj~i",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "KbXtC0oN+$`-[]{]){fG",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "ByAW(h}3gJyd:vLY9;$C",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "ZI+%b$*6P=}YCNK1?;B%",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "CD%~rwx4Qr3A%M*;?-GN",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "CPgU*bH_r2a4s!`$OFE6",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "8`[gX[|VcCr%SV%8wW4X",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "`yjaV~/X`:xHu`~EGJD9",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "@s1aRksj9^5a(i}Qoyjr",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "_/G,IA8[jXH0Da^|tLWd",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "TMZlaXy7`(Ker=qY[KmS",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "Wabvp7hL;Sv:iN^2qJtC",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "-Pwq39|1WHC)k-H4Q4Q`",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "|}?rQ[4T#WJsG1@f`[VC",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": ":8w5!X6Y;.]^FI^DY0J=",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "eq^7N9OVjQOrVwvLykT/",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "LvAoJOi1vsy]8!;7O@7L",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "qYUZR8RykE#A_)(5i]qr",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "z92F?uNh4$l/TPuS;7RO",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "B#CEAVmO=~LW2Xh+%GRf",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "E{/=^5r;+aVA7X*imVFn",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "jJW=7U.nNS2Y{DqgU-2b",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "Qy_;:FDJE(~HmX!#eWbm",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "93dXsR_3s?E-IkDe_Ewf",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "pbsPrbI,zxp595.EEH04",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "E:d4J5}sTY.{)r+k_HT5",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "PM8F,4_,Ev,S-x=*s,|U",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "J:bD1[AJevZn-#y#8}]#",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "CW]TG_lUtHqL81Y,OcZ;",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "of2*KAjlZZRF,4Q0*@eE",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "js,4zX^([2AZrCx6/jWY",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "F{#Updy=oRHg.$R3MODo",
      "name": "보석 상점"
    },
    {
      "id": "Ek:5yv3s|PF-]xi{ROQM",
      "name": "Map/Wave"
    },
    {
      "id": "yYI[{D,uit21SO_lUluy",
      "name": "Map/Wave/StringId"
    },
    {
      "id": ";H`vkq^C/W8IdRJ-#jIW",
      "name": "Map/Wave/Step"
    },
    {
      "id": "$0id``@8We7bR!F@{b.4",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "6ji6Z$As$U=?*^_`Bmp~",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "haV+evEyYXpN85{NOBM_",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "!eP)g[a]cC~||~f5TQiZ",
      "name": "Map/Wave/State"
    },
    {
      "id": "#aSeu|V/pa%^j8469buU",
      "name": "Gem shops"
    },
    {
      "id": "UZFG;J)4/H^Z-%{m?L$v",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "g48`hu%2Yg|4w]gYoW;r",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "n:lE@@,#!z$HcA2#j/YK",
      "name": "Zem"
    },
    {
      "id": "nZi{Sbxz{5?+n/~3z%{R",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "?t}N-9zkBqs$AF@zXpx;",
      "name": "Gem"
    },
    {
      "id": ",0Ic~r/_$mLG!%D,%euw",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "rTNCZu5%i7Suz*Vc}2,F",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "%%kE}pZ.I2|8nKZ6q){X",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "xQ?H#G~f(P/`AdejO6|b",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "!8PE5g/.lwjg)UKWRoN-",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "w!S+HHk,K?gS,Q,J3yzv",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "z%^0bXr0?^=N-*LzzGle",
      "name": "Map/IsStart"
    },
    {
      "id": "EM0#}MU#XD](}unvwY!W",
      "name": "Map/CanStart"
    },
    {
      "id": "1UR@@@z^nXY8e#zj{uva",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "?4,(tFHY[rrPt/GzpTj)",
      "name": "Map/Player/Moving"
    },
    {
      "id": "-LZnM^@*:x74Io#os_aH",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "F1l3$3%h?LlC!fe(SM`9",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "XFX?;qC0sj9aiAhIDA;R",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "|PNuc9O[L1(/,cMU1}B?",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "ebZw8n9qkFv3Nnb}fx+h",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "u8}t2~NKdLvHFZ2nE.hg",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "KDm5cTzgU9nWt:dJTiq-",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "?Z~kq/Zq}]oY8.RLG)Ww",
      "name": "@Map/Progress"
    },
    {
      "id": "xwfi+zVL]b}5.,YhxA-m",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "KE.B,=5zswEiDd~uqrDW",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "w$#O:+[ClvXdvaI,FqZk",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "sq`qBCm%fE6r#,PabCSo",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "^?M;?:CPQqAmfQ+*Ig1#",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "*f~DHi@K4(tSr#?G%B6T",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "HzxeU`#UFXGWh,dSnxKP",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "3/N(A_XA3u9XuBeZ1#`u",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "NAU@*X9#d~66*)(pwQv;",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "0?~[bwsNj]uZj)aksImN",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "sQ(`Mct#hCI/@0;[jfv]",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "BN+#iPQ-/_.SH$63?)a^",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "o/MS|aVp#-6]xxSZ_gV+",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "]!lDQ{KLTIy~P~zFDheM",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "Z.w.{Ow[H3abfI;loG9*",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "l3#dftI:(Y^N9^.#1m:9",
      "name": "@Skill/Variable/09"
    },
    {
      "id": ";vrS@;9Rb~s0y[0}drrO",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "9qpF^gzZoQd2[3.o_p|#",
      "name": "Map/DisplayWinningTeam"
    },
    {
      "id": "(zyWQ#yP$S+FQrqr[@U#",
      "name": "🚨 Scout rewards maxed out!\nCollect Gold💰 & Gems💎, and power up!\nPlay Hamster Combat now! 👉 [Play Now]"
    },
    {
      "id": ",f^?bcGbAx_]Vhn0Furv",
      "name": "@Map/WaveStartPlayerPosition"
    }
  ]
}