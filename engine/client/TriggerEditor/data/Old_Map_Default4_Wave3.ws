{
  "blocks": {
    "blocks": [
      {
        "id": "l=NnBL!b}`w/9T6h~W0*",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "TYPE": "board",
                "VAR": {
                  "id": "/Jy:K_G7;g_[Z!4p5xKZ"
                }
              },
              "id": "3#+Wmu.GOTOFc`e.SpA!",
              "inputs": {
                "VALUE": {
                  "block": {
                    "fields": {
                      "NUM": 1
                    },
                    "id": "VpezWCZ1Y8rIR^x{|+,T",
                    "type": "math_number"
                  }
                }
              },
              "next": {
                "block": {
                  "fields": {
                    "TYPE": "board",
                    "VAR": {
                      "id": "F//i`5m5GJ/iAUoeO`l["
                    }
                  },
                  "id": "RAY.?)UrKxaQJjmaW7-*",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "NUM": 1
                        },
                        "id": "YwfZBCkFwk?.1/f+b86D",
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
                                "id": "[#Z`WwjGGpos0i;%ZTt`"
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
                          "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;name&quot;:&quot;PlayerId&quot;},{&quot;comment&quot;:&quot;웨이브 숫자 (시작 웨이브가 1)&quot;,&quot;name&quot;:&quot;Offset&quot;},{&quot;comment&quot;:&quot;이벤트 문자열 키&quot;,&quot;name&quot;:&quot;StringKey&quot;}]\"></mutation>",
                          "fields": {
                            "NAME": "boardMethod:SendWaveStartedEvent",
                            "THIS": false
                          },
                          "id": "P_nx}UqPM~$-tlIC}er4",
                          "next": {
                            "block": {
                              "fields": {
                                "NAME": "Map_EncounterTraitWaveEnd",
                                "THIS": false
                              },
                              "id": ",3`CnXxw#^zUYG;qn_#f",
                              "type": "trigger_call"
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
                                    "id": "En?L7bayWv(pxGV.f*DW"
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
                              "id": "F//i`5m5GJ/iAUoeO`l["
                            }
                          },
                          "id": "5+@~fkT[ej9rg:/oyLw,",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 0
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
        "x": 835,
        "y": 925
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
                        "id": "b9t6IgQ;Z$262.i5kb84"
                      }
                    },
                    "id": "y]Fq-s9igOvuu2;DIRE|",
                    "type": "variables_get"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "NUM": 3
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
        "next": {
          "block": {
            "id": "lA^LS.y-o:^t[$wy=15X",
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
                          "TEXT": "Default4_Battle_03_01"
                        },
                        "id": "cqPJ0fK)(9r!V9%?liMJ",
                        "type": "text"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "fields": {
                        "TYPE": "board",
                        "VAR": {
                          "id": "zP9v=6@H_Fow55U(;_=g"
                        }
                      },
                      "id": "HfNB7uuim_py1BlOYHQ{",
                      "inputs": {
                        "VALUE": {
                          "block": {
                            "fields": {
                              "THIS": false,
                              "VAR": "boardVariable:Tick"
                            },
                            "id": "g9,47lT]}aLt8?.SpfY!",
                            "type": "variables_get_reserved"
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
                          "id": "*BJ@S]B}C*3I;MxK*,+^",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "NUM": 1
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
                                  "id": "F//i`5m5GJ/iAUoeO`l["
                                }
                              },
                              "id": "tu@/c1k_hJ1!S5Q!6iaD",
                              "inputs": {
                                "VALUE": {
                                  "block": {
                                    "fields": {
                                      "NUM": 0
                                    },
                                    "id": ",RgeuzXt;QOK5G=S.?1x",
                                    "type": "math_number"
                                  }
                                }
                              },
                              "next": {
                                "block": {
                                  "fields": {
                                    "TYPE": "board",
                                    "VAR": {
                                      "id": "gt}Jgm}QG_S6_)N8qe]V"
                                    }
                                  },
                                  "id": "E(6t_!s=|:NIO@rMUND@",
                                  "inputs": {
                                    "VALUE": {
                                      "block": {
                                        "fields": {
                                          "NUM": 1
                                        },
                                        "id": "Kyf)}h-T~$0Bd%a?VX#9",
                                        "type": "math_number"
                                      }
                                    }
                                  },
                                  "next": {
                                    "block": {
                                      "fields": {
                                        "TYPE": "board",
                                        "VAR": {
                                          "id": "En?L7bayWv(pxGV.f*DW"
                                        }
                                      },
                                      "id": "uZre{/{en(LaF4yn$Dj!",
                                      "inputs": {
                                        "VALUE": {
                                          "block": {
                                            "fields": {
                                              "OP": "ADD"
                                            },
                                            "id": "5G=90)WjQBVa}%8_K1{5",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "fields": {
                                                    "THIS": false,
                                                    "VAR": "boardVariable:Tick"
                                                  },
                                                  "id": "]+WN9r~-e`up0Fb}Wx_Y",
                                                  "type": "variables_get_reserved"
                                                },
                                                "shadow": {
                                                  "fields": {
                                                    "NUM": 1
                                                  },
                                                  "id": "3?@0N.c_*IqZMoW$|bB!",
                                                  "type": "math_number"
                                                }
                                              },
                                              "B": {
                                                "block": {
                                                  "fields": {
                                                    "NUM": 1800
                                                  },
                                                  "id": "nskCssN[Opk^x^CkiC9~",
                                                  "type": "math_number"
                                                },
                                                "shadow": {
                                                  "fields": {
                                                    "NUM": 1
                                                  },
                                                  "id": "A*$bXMP|qL1WF5PO)KIE",
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
                                          "extraState": "<mutation itemCount=\"4\" metadata=\"[{&quot;name&quot;:&quot;PlayerId&quot;},{&quot;comment&quot;:&quot;웨이브 숫자 (시작 웨이브가 1)&quot;,&quot;name&quot;:&quot;Offset&quot;},{&quot;comment&quot;:&quot;웨이브 시작 대기 시간 (초 단위)&quot;,&quot;name&quot;:&quot;Duration&quot;},{&quot;comment&quot;:&quot;이벤트 문자열 키&quot;,&quot;name&quot;:&quot;StringKey&quot;}]\"></mutation>",
                                          "fields": {
                                            "NAME": "boardMethod:SendWaveQueuedEvent",
                                            "THIS": false
                                          },
                                          "id": "]*^mc;UvNXfyDGqfys;`",
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
                      "type": "variables_set"
                    }
                  },
                  "type": "debug"
                }
              },
              "IF0": {
                "block": {
                  "fields": {
                    "OP": "AND"
                  },
                  "id": "+^#cG1`]fLnh2E@-5T%z",
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
                                "NUM": 3
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
                                        "id": "y%%l?*_%JXp)m~Jd[vzT"
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
                                        "id": "hrg5qh(,s]msZU8vZK}s"
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
                        "id": "tS|NFvDL+jQ)gdhB7#I0",
                        "inputs": {
                          "A": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": "gt}Jgm}QG_S6_)N8qe]V"
                                }
                              },
                              "id": "@/JpLN1tGD0S]wlXB^mB",
                              "type": "variables_get"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "NUM": 0
                              },
                              "id": "9`/}Lcv##MnaS*x`QY|d",
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
        "type": "controls_if",
        "x": 835,
        "y": -2549
      },
      {
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
                                    "id": "1Y#G_X81@d#F9_*saP8B"
                                  }
                                },
                                "id": "ko/RKS#M5@m-fgL9SEjB",
                                "type": "variables_get"
                              }
                            },
                            "ARG1": {
                              "block": {
                                "fields": {
                                  "VAR": "Location/SPAWNAREA_MOB_003"
                                },
                                "id": "P.H6oSh6cwM=+7Sa||V%",
                                "type": "stringkeys_get"
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
                                                "id": "zP9v=6@H_Fow55U(;_=g"
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
                                        "NUM": 195
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
                                  "NUM": 105
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
                                    "id": "zP9v=6@H_Fow55U(;_=g"
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
                            "NUM": 930
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
                              "id": "zP9v=6@H_Fow55U(;_=g"
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
                      "NUM": 105
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
            "id": "ahBkYP)ArwsQr~GjgR);",
            "inputs": {
              "DO0": {
                "block": {
                  "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "boardMethod:AddUnit",
                    "THIS": true
                  },
                  "id": "nS`hglSdPWvdv?9AL)C8",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "extraState": "<mutation></mutation>",
                        "fields": {
                          "TYPE": "board",
                          "VAR": {
                            "id": "~AMtBZf`H(*%Yoiis6Zm"
                          }
                        },
                        "id": "Y^sSxR`qZd3P`Jj:pKWW",
                        "type": "variables_get"
                      }
                    },
                    "ARG1": {
                      "block": {
                        "fields": {
                          "VAR": "Location/SPAWNAREA_MOB_003"
                        },
                        "id": "5SgtrX=R?}~JG|BzH{At",
                        "type": "stringkeys_get"
                      }
                    },
                    "ARG4": {
                      "block": {
                        "fields": {
                          "NUM": 0
                        },
                        "id": "{jG|7}{ccd5_Dp{;/n:8",
                        "type": "math_number"
                      }
                    },
                    "ARG5": {
                      "block": {
                        "fields": {
                          "VAR": "Enemy"
                        },
                        "id": "tU7EJKQhyL_+d~JO!Omc",
                        "type": "teamtag_get"
                      }
                    },
                    "ARG6": {
                      "block": {
                        "fields": {
                          "NUM": 1
                        },
                        "id": "+5p=h5iWPxWRr5}WfNR(",
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
                  "id": "~_xSfvjSpS9zJc2_3uHP",
                  "inputs": {
                    "A": {
                      "block": {
                        "id": "5f*-D9mhrb,k=d6=K)|8",
                        "inputs": {
                          "DIVIDEND": {
                            "block": {
                              "fields": {
                                "OP": "MINUS"
                              },
                              "id": "S=V]C5EGlky(U9jv^_Cs",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "THIS": false,
                                      "VAR": "boardVariable:Tick"
                                    },
                                    "id": "Bh(3bw9urrCsV`wdPtXU",
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
                                        "id": "zP9v=6@H_Fow55U(;_=g"
                                      }
                                    },
                                    "id": "PWNN=F7YB]gvDGfaw/Wd",
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
                                "NUM": 9999
                              },
                              "id": "NLt{XK~^|C$HuQ3NA21H",
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
                          "NUM": 270
                        },
                        "id": "@`|41Xx^`9LItOicg%]9",
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
                "id": "^f-bG-Og#NODY~_DQ{j1",
                "inputs": {
                  "DO0": {
                    "block": {
                      "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                      "fields": {
                        "NAME": "boardMethod:AddUnit",
                        "THIS": true
                      },
                      "id": ",I!v4Vpso7DF%$ycxf2^",
                      "inputs": {
                        "ARG0": {
                          "block": {
                            "extraState": "<mutation></mutation>",
                            "fields": {
                              "TYPE": "board",
                              "VAR": {
                                "id": ";8#e-4(y0VYZXfwXDhTB"
                              }
                            },
                            "id": "W{2Z$j,dT-D1Qx5sD(ot",
                            "type": "variables_get"
                          }
                        },
                        "ARG1": {
                          "block": {
                            "fields": {
                              "VAR": "Location/SPAWNAREA_MOB_003"
                            },
                            "id": "M`|pE5VRQImfsH+OK]EW",
                            "type": "stringkeys_get"
                          }
                        },
                        "ARG4": {
                          "block": {
                            "fields": {
                              "NUM": 0
                            },
                            "id": "epfgEgWnid(0TTe0xx#o",
                            "type": "math_number"
                          }
                        },
                        "ARG5": {
                          "block": {
                            "fields": {
                              "VAR": "Enemy"
                            },
                            "id": "UgzkvGu7Py/mU0Et|ohx",
                            "type": "teamtag_get"
                          }
                        },
                        "ARG6": {
                          "block": {
                            "fields": {
                              "NUM": 1
                            },
                            "id": "[(QV:%pF5[d+`%zs,cXS",
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
                      "id": "eKYGW[n7Q=P_N1W]l}zp",
                      "inputs": {
                        "A": {
                          "block": {
                            "id": "7{QNypnlmM.w%$F4^/Xe",
                            "inputs": {
                              "DIVIDEND": {
                                "block": {
                                  "fields": {
                                    "OP": "MINUS"
                                  },
                                  "id": "J|UOS%xho$K.D.nXd[)3",
                                  "inputs": {
                                    "A": {
                                      "block": {
                                        "fields": {
                                          "THIS": false,
                                          "VAR": "boardVariable:Tick"
                                        },
                                        "id": "SF+IUXI:#6L,u~9|JCPd",
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
                                            "id": "zP9v=6@H_Fow55U(;_=g"
                                          }
                                        },
                                        "id": "K:ZYdbnG@%_mF$!li)vm",
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
                                    "NUM": 9999
                                  },
                                  "id": ";(:U2!I)OVgsstr$jp~K",
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
                              "NUM": 900
                            },
                            "id": "(TV?:R6xk2;Ey8,tg`{`",
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
                    "id": "?0rdv+aW%RDBm/9Ex?:3",
                    "inputs": {
                      "DO0": {
                        "block": {
                          "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                          "fields": {
                            "NAME": "boardMethod:AddUnit",
                            "THIS": true
                          },
                          "id": "|9^cJ1y!jAZTb8We7F4+",
                          "inputs": {
                            "ARG0": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "board",
                                  "VAR": {
                                    "id": ";8#e-4(y0VYZXfwXDhTB"
                                  }
                                },
                                "id": "A@Dy}_#*JN~Y;|yA2uhL",
                                "type": "variables_get"
                              }
                            },
                            "ARG1": {
                              "block": {
                                "fields": {
                                  "VAR": "Location/SPAWNAREA_MOB_003"
                                },
                                "id": "|STk#T)Na}d,4Am^3aUx",
                                "type": "stringkeys_get"
                              }
                            },
                            "ARG4": {
                              "block": {
                                "fields": {
                                  "NUM": 0
                                },
                                "id": "u7wH*h@(2GXia5LvI@ZL",
                                "type": "math_number"
                              }
                            },
                            "ARG5": {
                              "block": {
                                "fields": {
                                  "VAR": "Enemy"
                                },
                                "id": "`pIgu2Z^2__^zcw$o9au",
                                "type": "teamtag_get"
                              }
                            },
                            "ARG6": {
                              "block": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "-B}aU=b|dW/]K}Nf3:Ph",
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
                          "id": "rJ4,GX`V);}hH83I=f^B",
                          "inputs": {
                            "A": {
                              "block": {
                                "id": "5lwLAU1(ot@:q[Vsg3=h",
                                "inputs": {
                                  "DIVIDEND": {
                                    "block": {
                                      "fields": {
                                        "OP": "MINUS"
                                      },
                                      "id": "pwl!#){Z0yF3zX-$+E6O",
                                      "inputs": {
                                        "A": {
                                          "block": {
                                            "fields": {
                                              "THIS": false,
                                              "VAR": "boardVariable:Tick"
                                            },
                                            "id": ".3tc)-U8w!x4m}F~u6t@",
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
                                                "id": "zP9v=6@H_Fow55U(;_=g"
                                              }
                                            },
                                            "id": ")~{|roF[Th)uj{[AHnmj",
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
                                        "NUM": 9999
                                      },
                                      "id": "2U+%=eMaVv-r6{.,VxQ4",
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
                                  "NUM": 930
                                },
                                "id": "p%*yW}fg2[qhf5zn+2-]",
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
                        "id": "HOiP0p(T}__Dd#I?32lm",
                        "inputs": {
                          "DO0": {
                            "block": {
                              "id": "[:WPx#;oG1*?uE,;u,*5",
                              "inputs": {
                                "DO0": {
                                  "block": {
                                    "id": "#bHnsyu0fau-2V,$=f:l",
                                    "inputs": {
                                      "DO0": {
                                        "block": {
                                          "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                          "fields": {
                                            "NAME": "boardMethod:AddUnit",
                                            "THIS": true
                                          },
                                          "id": "?Y:|oq7R$c,fJ8Z}dIY|",
                                          "inputs": {
                                            "ARG0": {
                                              "block": {
                                                "extraState": "<mutation></mutation>",
                                                "fields": {
                                                  "TYPE": "board",
                                                  "VAR": {
                                                    "id": "z5hH`n~?0Vp,}W/9B=X4"
                                                  }
                                                },
                                                "id": "fPwlcdB),5s!3gO}Ai3K",
                                                "type": "variables_get"
                                              }
                                            },
                                            "ARG1": {
                                              "block": {
                                                "fields": {
                                                  "VAR": "Location/SPAWNAREA_MOB_003"
                                                },
                                                "id": "?6AQF,g)f9Ovx*36vA;O",
                                                "type": "stringkeys_get"
                                              }
                                            },
                                            "ARG4": {
                                              "block": {
                                                "fields": {
                                                  "NUM": 0
                                                },
                                                "id": "3Zy.48GaWs5OL6l~k{my",
                                                "type": "math_number"
                                              }
                                            },
                                            "ARG5": {
                                              "block": {
                                                "fields": {
                                                  "VAR": "Enemy"
                                                },
                                                "id": "PMx)WICD]^3~WC%PD6KW",
                                                "type": "teamtag_get"
                                              }
                                            },
                                            "ARG6": {
                                              "block": {
                                                "fields": {
                                                  "NUM": 1
                                                },
                                                "id": "oprHrvN18%H7k1MowYPN",
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
                                          "id": "QLy_}M%V@?RNeWOk42`w",
                                          "inputs": {
                                            "A": {
                                              "block": {
                                                "id": "(ZGL^NeqR1!DJ%IHLE;N",
                                                "inputs": {
                                                  "DIVIDEND": {
                                                    "block": {
                                                      "fields": {
                                                        "OP": "MINUS"
                                                      },
                                                      "id": "u^?zR]!9|pe;Kug62n9h",
                                                      "inputs": {
                                                        "A": {
                                                          "block": {
                                                            "fields": {
                                                              "THIS": false,
                                                              "VAR": "boardVariable:Tick"
                                                            },
                                                            "id": "#V$!i=8NP5j@`yHW9GX.",
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
                                                                "id": "zP9v=6@H_Fow55U(;_=g"
                                                              }
                                                            },
                                                            "id": "f47hY8E`%5@/MU#O%n!f",
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
                                                        "NUM": 165
                                                      },
                                                      "id": "6Fk*F*iTIbT`}e;x(4c(",
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
                                                  "NUM": 90
                                                },
                                                "id": "DUNsd4JiVn3/ZVtDjMrH",
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
                                    "id": "1HX?8bP5B9GB:sMz[H6X",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "fields": {
                                            "OP": "MINUS"
                                          },
                                          "id": "B_5?na`~@0Pg+X3`+pxB",
                                          "inputs": {
                                            "A": {
                                              "block": {
                                                "fields": {
                                                  "THIS": false,
                                                  "VAR": "boardVariable:Tick"
                                                },
                                                "id": "+3@9FjJZ%7)`/?L%hHpI",
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
                                                    "id": "zP9v=6@H_Fow55U(;_=g"
                                                  }
                                                },
                                                "id": "D+LeU=.8XwTCX$$qT!(_",
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
                                            "NUM": 1800
                                          },
                                          "id": "3z]owW=SjNcc@5@VG66g",
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
                              "id": "(uaC%o8sr-ZWtgVPk~7M",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "OP": "MINUS"
                                    },
                                    "id": "tQFuyizRF/*R7(%?n[OE",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "fields": {
                                            "THIS": false,
                                            "VAR": "boardVariable:Tick"
                                          },
                                          "id": "ccvoNmOk2B8Cd18[7Lc}",
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
                                              "id": "zP9v=6@H_Fow55U(;_=g"
                                            }
                                          },
                                          "id": "|@*-:4o|yV7U;M.w90{F",
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
                                      "NUM": 1080
                                    },
                                    "id": "EH=lxDcHueFRQ{))x0WS",
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
                            "id": "P$J(ysJDaK7n@YAoQqUO",
                            "inputs": {
                              "DO0": {
                                "block": {
                                  "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                  "fields": {
                                    "NAME": "boardMethod:AddUnit",
                                    "THIS": true
                                  },
                                  "id": "m;|L,U-J%/d:3LqW^d_9",
                                  "inputs": {
                                    "ARG0": {
                                      "block": {
                                        "extraState": "<mutation></mutation>",
                                        "fields": {
                                          "TYPE": "board",
                                          "VAR": {
                                            "id": "~AMtBZf`H(*%Yoiis6Zm"
                                          }
                                        },
                                        "id": "j=DEzt:Ff/4[q#%eo/U=",
                                        "type": "variables_get"
                                      }
                                    },
                                    "ARG1": {
                                      "block": {
                                        "fields": {
                                          "VAR": "Location/SPAWNAREA_MOB_003"
                                        },
                                        "id": "u2^/M?^hE3u/M7(nerLn",
                                        "type": "stringkeys_get"
                                      }
                                    },
                                    "ARG4": {
                                      "block": {
                                        "fields": {
                                          "NUM": 0
                                        },
                                        "id": "TU2CrvV@7Jsx+/R%e0%s",
                                        "type": "math_number"
                                      }
                                    },
                                    "ARG5": {
                                      "block": {
                                        "fields": {
                                          "VAR": "Enemy"
                                        },
                                        "id": "Bo?Fm9}o$]vBwNYQ5|v6",
                                        "type": "teamtag_get"
                                      }
                                    },
                                    "ARG6": {
                                      "block": {
                                        "fields": {
                                          "NUM": 1
                                        },
                                        "id": "o1bV8cr)TE?6o_JfTo/.",
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
                                  "id": "+.?kw:Kk?MQ[onWi}9qv",
                                  "inputs": {
                                    "A": {
                                      "block": {
                                        "id": "#K.JF|=AG9sxg=KU7`-a",
                                        "inputs": {
                                          "DIVIDEND": {
                                            "block": {
                                              "fields": {
                                                "OP": "MINUS"
                                              },
                                              "id": "w0S=^EuKg96M+GKAq0rm",
                                              "inputs": {
                                                "A": {
                                                  "block": {
                                                    "fields": {
                                                      "THIS": false,
                                                      "VAR": "boardVariable:Tick"
                                                    },
                                                    "id": "q,OmrY=F?3c/bi5SVyhb",
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
                                                        "id": "zP9v=6@H_Fow55U(;_=g"
                                                      }
                                                    },
                                                    "id": "RNdk_vw~3(OyL3lxmnXI",
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
                                                "NUM": 9999
                                              },
                                              "id": "u-}#O}xdUatqvlr5%:7!",
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
                                          "NUM": 1365
                                        },
                                        "id": "9?e/AEf063x;7cJb:xI|",
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
                                "id": "ZEb-S-0TyGnouKyoHmgy",
                                "inputs": {
                                  "DO0": {
                                    "block": {
                                      "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                      "fields": {
                                        "NAME": "boardMethod:AddUnit",
                                        "THIS": true
                                      },
                                      "id": "!F31WC~Q0:4r~,#LaC(G",
                                      "inputs": {
                                        "ARG0": {
                                          "block": {
                                            "extraState": "<mutation></mutation>",
                                            "fields": {
                                              "TYPE": "board",
                                              "VAR": {
                                                "id": "z5hH`n~?0Vp,}W/9B=X4"
                                              }
                                            },
                                            "id": "~7o4fCcLPtv]hU$x.mKI",
                                            "type": "variables_get"
                                          }
                                        },
                                        "ARG1": {
                                          "block": {
                                            "fields": {
                                              "VAR": "Location/SPAWNAREA_MOB_003"
                                            },
                                            "id": "AX:X7{Dn,XWHQlu@FjvU",
                                            "type": "stringkeys_get"
                                          }
                                        },
                                        "ARG4": {
                                          "block": {
                                            "fields": {
                                              "NUM": 0
                                            },
                                            "id": "+S9uPbyF|s1;waB{IlsC",
                                            "type": "math_number"
                                          }
                                        },
                                        "ARG5": {
                                          "block": {
                                            "fields": {
                                              "VAR": "Enemy"
                                            },
                                            "id": "H+F.#]FixiJd_OXGq7t^",
                                            "type": "teamtag_get"
                                          }
                                        },
                                        "ARG6": {
                                          "block": {
                                            "fields": {
                                              "NUM": 1
                                            },
                                            "id": "*}_z.^*_Fm)AYr]@nU3P",
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
                                      "id": "%zP,$pZd}gBKU#:[kM@z",
                                      "inputs": {
                                        "A": {
                                          "block": {
                                            "id": "7gz?!?bPt%D[a#B4n+fr",
                                            "inputs": {
                                              "DIVIDEND": {
                                                "block": {
                                                  "fields": {
                                                    "OP": "MINUS"
                                                  },
                                                  "id": "Ns4KiE|Rry3g$:H5D(gB",
                                                  "inputs": {
                                                    "A": {
                                                      "block": {
                                                        "fields": {
                                                          "THIS": false,
                                                          "VAR": "boardVariable:Tick"
                                                        },
                                                        "id": "(;44gv{nT?f?Nx$;5z2!",
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
                                                            "id": "zP9v=6@H_Fow55U(;_=g"
                                                          }
                                                        },
                                                        "id": "vbI|F`sPC?6p[1BX@H!2",
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
                                                    "NUM": 9999
                                                  },
                                                  "id": "g|SPRHb3hC!R(BJaX3hG",
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
                                              "NUM": 1380
                                            },
                                            "id": "k8JhIF]uO`|$b3slFaP]",
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
                                    "id": "a`jFBabYQ1v/p~SsmxR(",
                                    "inputs": {
                                      "DO0": {
                                        "block": {
                                          "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                          "fields": {
                                            "NAME": "boardMethod:AddUnit",
                                            "THIS": true
                                          },
                                          "id": "z^$2r7@$L#~!4hLJ]#l7",
                                          "inputs": {
                                            "ARG0": {
                                              "block": {
                                                "extraState": "<mutation></mutation>",
                                                "fields": {
                                                  "TYPE": "board",
                                                  "VAR": {
                                                    "id": ";8#e-4(y0VYZXfwXDhTB"
                                                  }
                                                },
                                                "id": "/sOK@IeQnk^GZQ8b5T[R",
                                                "type": "variables_get"
                                              }
                                            },
                                            "ARG1": {
                                              "block": {
                                                "fields": {
                                                  "VAR": "Location/SPAWNAREA_MOB_003"
                                                },
                                                "id": "8a-jEe!r:cD(mBf@g3zx",
                                                "type": "stringkeys_get"
                                              }
                                            },
                                            "ARG4": {
                                              "block": {
                                                "fields": {
                                                  "NUM": 0
                                                },
                                                "id": "A3K95`}6$FXtj#iXgh^J",
                                                "type": "math_number"
                                              }
                                            },
                                            "ARG5": {
                                              "block": {
                                                "fields": {
                                                  "VAR": "Enemy"
                                                },
                                                "id": "g3guhcm|[h%k]x2bRthi",
                                                "type": "teamtag_get"
                                              }
                                            },
                                            "ARG6": {
                                              "block": {
                                                "fields": {
                                                  "NUM": 1
                                                },
                                                "id": "wj|S`,P}~kWBI2aqZxJL",
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
                                          "id": "{.{wHH,E%y+br0Dz^x{D",
                                          "inputs": {
                                            "A": {
                                              "block": {
                                                "id": "TSb#w(MMqz]DjC$$wmz/",
                                                "inputs": {
                                                  "DIVIDEND": {
                                                    "block": {
                                                      "fields": {
                                                        "OP": "MINUS"
                                                      },
                                                      "id": "?3WfZ{*49#8ydi#P]B:M",
                                                      "inputs": {
                                                        "A": {
                                                          "block": {
                                                            "fields": {
                                                              "THIS": false,
                                                              "VAR": "boardVariable:Tick"
                                                            },
                                                            "id": "?-i|1f]WBv**{:GtcS;;",
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
                                                                "id": "zP9v=6@H_Fow55U(;_=g"
                                                              }
                                                            },
                                                            "id": "v4ta?0(n}kDrP?!E3kFa",
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
                                                        "NUM": 9999
                                                      },
                                                      "id": "#oT2iaewx]k-i:[@patS",
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
                                                  "NUM": 1560
                                                },
                                                "id": "Vei6fP%G?2JpT/~mTVPP",
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
                "type": "controls_if"
              }
            },
            "type": "controls_if"
          }
        },
        "type": "controls_if",
        "x": 835,
        "y": -1845
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Old_Map_Default4_Wave3",
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
      "id": "fYWOO678!Ba5?BOU+pX6",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "1|T$qzh,f0n8/QJzJ._E",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "m}_yt}(OXhh6W}3t:Q@T",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "kJ@$^=f4t-h?+q1`jKdt",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "e,iuEjz=2q#DCJw$DQ!%",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "KistgctTLVHC-@D@NHS^",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "(q.cd^u+Yw|0qT*gM;F(",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "*Z=Ndtl]7.s73kZNmMC9",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "nV$3:`:?o0:a.hdtVc@#",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "7R-S[w6Q2%WmCRK{7/,N",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "0Ju$Zj]w]^GJpiS2IM)a",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "T8H39F)fJrlEroAd6ed7",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "3?rf_Zn(W5%Pre(pE{[P",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "Dp)E_csU30/*P4lDN^W3",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "Hokh^w$EYGmPU^|S8r9@",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "OK@,QG]8+x}VE$Aq[?c:",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "@J~r.QF/s/K57HFB?Zm;",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "FAgijD)44Os=VVV7?//t",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "1Q:luIK!3|@TYbd}gjHL",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "[yXb?8{9rTjWLc4s-C=w",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "MQFH$O%ql+8,`pg,C!f_",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": ",z?-{}Oa.puv7PUu9FZo",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "HaEnvH$)~%kzVAKgB5iA",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "{v)i|IRr@;|d?Rw5K1,|",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "SG]JeV6piJl$}G1`BG|/",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "Wg$CN-m!]Q..^8UgQ4Op",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "h;G3*6`y#Q(QK4,mLf9-",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "iza+bDBF4hgm.svdl^1c",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "Z!r_J)alJB_}y~ou].B_",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "4t%[SNFETt@i!647T9GP",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "/R)C$-7yc3uRco!YmQH9",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "y=#V8#tkB;lmD}S)-_uR",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "S-[v?wu^bU@L{jUJd$kS",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "(?Jb{j~|-N)]y.Yxww1[",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": ".Qz$tT3VKuvYgp-1d2G;",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "vRPqk?_~kv6(O~@yB=0+",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "!wwR$2(tuNx[7!%uc{*h",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "N)6AsFxG-P/=G._~B0nv",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "wB:pWF#;21!FMCv^M)8W",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "/@ezC|}I{._Quhf33:8D",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "A#l4Px0dcmhY=)J~;?X!",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "f:@E:@%voryl%UXIB]tg",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "/bBZ`=P+OI):FZZCtsGi",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "3I+#yum;LEQQ6h%BOcoH",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "1AEWk!jcz5I%*zkh.V0/",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "w/d9`qfB_Rv!cj*y%v]?",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "$|*z*^ag7Ny2a)6mp-.;",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "v=(b.TRbQGB*G^:]Goi`",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": "kb|F.c*n=-W4W*Y7bR6,",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "1?8bb4ma68dY%`TEbbM7",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "N?4T2BCZZ?T)iH;xwKtn",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "8bq[+AJ5uGRb*iBt;+bS",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "7`i.S^Xgu0xG.]mK)(+b",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "oP%ayl#`+$JeJ8N?uf7_",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "r{3.tN7f]oS^at9$yf}p",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "Da1b`eNeTEa*Y{nBh87|",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "xiI/Lr,6w|Szd{9OXB8k",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "J%yLN9M)gxN-wbO:[J9b",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": ";:yiI^feN~x`E#LPH[EP",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "FKt(S8D%CS7i|w6.zf%w",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": "u(L_(nv*+6fAqo!=?~`q",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": ":b?]T6NlnxuEW)]qF_BG",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "_e,Wp;JyZ8l5mv]/wW^Q",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "^Y,-#A|lCh#Jx)ZyW5gk",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": "T#wc(oG%lZD`~@)]}B,{",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "yTPO4k9,H95$5IXj_pC|",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "Ad@%YBeul)FLble{Fb#=",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "PbVCnd|-M:pZ4EKGt,T$",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "huI%3`NLkU5Z,MU$|4#j",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "W[-xXUAJqAw%lga8KnOT",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "$]XL[OtIrRY86JT:fL8+",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "7v$ZF(VviV{!tYlVsw$C",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "R8IIKCMJc:-!+%/)w*2B",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "GF*57#+Pr;V@66%!r;aT",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "$95|(dxu=l600hs$SQNw",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "uahKC%z)$Q9tZ|cN(p0U",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "KH;mVv#kQ;/H{5U{(x6J",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "]+5xZ.Q%Om9sP7[^3{/H",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "_bTs~t?8XQ7)ozaA+/me",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "+d;;!%s.m#{?N#c|ks|i",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "QxX0yIG9dXhfz~xvdfCh",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "?vi7:awjhUBjwg*lE{:[",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "EscEE2n(_`L)la?.HBW4",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "GBDjHoVMIar^$#_xMEWN",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "L~}f[9hS1(z0CHhcjs[V",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "jKYHQM:)v@h,zTna;:Zi",
      "name": "@Map/Variable01"
    },
    {
      "id": "iU*/cUfbN_V!x0BL[Bh[",
      "name": "@Map/Variable02"
    },
    {
      "id": "wNS(*MRhTZ?ZPx1%b|^S",
      "name": "@Map/Variable03"
    },
    {
      "id": "4uWDL{j-!pPFY7B8$Xh@",
      "name": "@Map/Variable04"
    },
    {
      "id": "gpZ!ddKL~o2}zqhJ+hjp",
      "name": "@Map/Variable05"
    },
    {
      "id": "zPmTW|-P@e~TB|ed$g*j",
      "name": "@Map/Encounter/Unit1ID"
    },
    {
      "id": "0[ZvBBZwTU]-5OGHl%BN",
      "name": "@Map/Encounter/Unit2ID"
    },
    {
      "id": "Z.#bV*%mfP?t.iX^MW8y",
      "name": "@Map/Encounter/Unit3ID"
    },
    {
      "id": "8C`3)@q20+8*JJ;ig=-[",
      "name": "@Map/Encounter/Unit4ID"
    },
    {
      "id": "bHCeFAB;avmd(Zy`NJK_",
      "name": "@Map/Encounter/Unit5ID"
    },
    {
      "id": "?/)KTJd],+#LS?x?0R]O",
      "name": "@Map/Encounter/Unit1Percent"
    },
    {
      "id": "*^jKhPlX`$)ah]KrL#Mm",
      "name": "@Map/Encounter/Unit2Percent"
    },
    {
      "id": "O,7:(;f`/2?*6}/RU]h%",
      "name": "@Map/Encounter/Unit3Percent"
    },
    {
      "id": "Stl+px_U.xmYk17Pj5-o",
      "name": "@Map/Encounter/Unit4Percent"
    },
    {
      "id": "k)?Br]WUiO-I*(ZlbmNd",
      "name": "@Map/Encounter/Unit5Percent"
    },
    {
      "id": "0]q6VSC(Zo3M|qePSV!F",
      "name": "Map/WaveStartTick"
    },
    {
      "id": "F30E3UWf=yv+`qx]WyQ(",
      "name": "@Unit/Variable01"
    },
    {
      "id": "YfK/}{i]L#3vJ-L}CZg^",
      "name": "@Unit/Variable02"
    },
    {
      "id": "Yq)2(IVlR70C@izm.+/G",
      "name": "@Unit/Variable03"
    },
    {
      "id": "d3E-3AKLC|f[xk-!69*^",
      "name": "@Unit/Variable04"
    },
    {
      "id": "icTgG*(k%)lxQR/RzvdV",
      "name": "@Unit/Variable05"
    },
    {
      "id": "/Jy:K_G7;g_[Z!4p5xKZ",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "kI(^aEU]9LSwD;3B3q}F",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "y`3|l~.AwE``]TaYZ2wg",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "Z?/D4]~foHQ6`OLL47C{",
      "name": "@Skill/Trait/BlastIncreaseKBPercent"
    },
    {
      "id": "tb$:RzD.=2_|c+x7]tYd",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "`f6%F)^MVVs5DM96HoZZ",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "5}I10dS{avPW+Hu5DxG%",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "{6-C;Tu!IP.vy:dDFKW3",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "7j7aRv!(]6E5zb:B`|@h",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "FPCj#P.BD/AbucMI#$oH",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "*(nVb{JzxAH8-$pt}Fb0",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "!^s{/6nbH.uKWuC~*u,n",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "+]t]K/RZN$~x4.XJKKe)",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "M?e9kV3gv6S4+k1$rpwh",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "BKYYtqzZG!_ufuxJNqL,",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "R$e~,K6(]`Q0tQG36_F#",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "$jelyON;zDG@Y$;SvFa*",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "r@_Juggig!?i[d_kb*Pt",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "HDtEO#yohrpf~5b$A.ua",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "pQfRu:7w`Z}[8,?M{H`,",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "U{CsAjq$Jq!y*JZY@-Yz",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "f;{BJAsQ-JXz!iXOs@~z",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "`S7TZ%0gw|]P:}nDeM[+",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "rAOY7bmY++cHe#ke_5#Y",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "ST+PA;ww@U~xTSloN(x,",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "EM[::Q@3(E+|ha*b;s%V",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "1Y#G_X81@d#F9_*saP8B",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "z5hH`n~?0Vp,}W/9B=X4",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": ";8#e-4(y0VYZXfwXDhTB",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "~AMtBZf`H(*%Yoiis6Zm",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "l@8GcKz^P[Kk1%|M[DLk",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "8n{`6@$tg,2A;R{Px}no",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "dar#u)AV*FXn9??OxM9)",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "%3^5NosB$!?EhO(ne8Lw",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": ";w*eknh^7q*GJ*9]R#QX",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "*B~swwR01~h?97X8$!z^",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "9e8mW=9^Y7/`W.8IN{s*",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "zP.tS6;VMRF~#YcJM?NM",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "1oeWit|C`M{1-)Y}LJ^4",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "]loNG*aGshHPc`Ut9v}|",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "AkF-uePksQV@]EoZv1d_",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "Z0({cxtv}[w=YpQ[Gcz1",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "5c|mgx/Y?m_qLjGe_!QJ",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "@3=vE=o6@X.:!QVr$B6A",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "LL,a|,us-V4L}*}](3:8",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": ".86Q%v]5u9e{;OFuodN8",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "~h-l?]MmsIeEupel/_a#",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "0:3^ZP[iNRYDvtqd,2C.",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "HayB1z.{}@fnumMb9][f",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "P4zNZ3urx?P8!wfni_w*",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "tp@DPL517ZQ!|^jn]yz`",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "VXR+o/w,3NqiLY$9~8QS",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "pf!E%!GL}1iW($/~/PoE",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "#K.;7gIV^WYOi/%Dvkzu",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": ".0_(Q0XJN6GxERNQa|P!",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "A!ML2?yNx.?Bh;^qR#4:",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "biiEQ{@n7%7gGsZ38zmI",
      "name": "보석 상점"
    },
    {
      "id": "b9t6IgQ;Z$262.i5kb84",
      "name": "Map/Wave"
    },
    {
      "id": "hhW.[0Ife553!xC_f}^/",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "gt}Jgm}QG_S6_)N8qe]V",
      "name": "Map/Wave/Step"
    },
    {
      "id": "ckU(4yg|1s4eG`hii,xY",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "zP9v=6@H_Fow55U(;_=g",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "En?L7bayWv(pxGV.f*DW",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "F//i`5m5GJ/iAUoeO`l[",
      "name": "Map/Wave/State"
    },
    {
      "id": "L$LT0!F^r#!T.bmU:#A~",
      "name": "Gem shops"
    },
    {
      "id": "Yta#xoQiEiaI`xj:.]Ll",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": ":n]+2AmHmLwW!roDGC7G",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "Gb!ag2Sz]hu82aZ{V[sC",
      "name": "Zem"
    },
    {
      "id": "!k(C3|;[MW+k5%)Yno)2",
      "name": "@Skill/Trait/ResetOnKill"
    }
  ]
}