{
  "blocks": {
    "blocks": [
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
                        "id": "Qz:v63kV8*L59jGRDHx("
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
            "id": "_Mn/4RCg7m|_#S`?2W%g",
            "inputs": {
              "DO0": {
                "block": {
                  "fields": {
                    "NAME": "Log"
                  },
                  "id": "bdj[q-N@z(MyQ;#x6#oJ",
                  "inputs": {
                    "TEXT": {
                      "block": {
                        "fields": {
                          "TEXT": "Default3_Battle_03_01"
                        },
                        "id": "?T9VmQS02-GEUQEqjg~[",
                        "type": "text"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "fields": {
                        "TYPE": "board",
                        "VAR": {
                          "id": "ec;fD/S5v@$zI1xMqqt`"
                        }
                      },
                      "id": "V{@E{[z4#cGBbfL$G!P$",
                      "inputs": {
                        "VALUE": {
                          "block": {
                            "fields": {
                              "THIS": false,
                              "VAR": "boardVariable:Tick"
                            },
                            "id": "C[Pr75trpUC^+h6D45B]",
                            "type": "variables_get_reserved"
                          }
                        }
                      },
                      "next": {
                        "block": {
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "rh;$L)r%,J*;M9NfCu:J"
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
                                  "id": "o,xKeQe}t5}Q]cui@aQG"
                                }
                              },
                              "id": "cQ^y$2(nO8@U8HVVaX2,",
                              "inputs": {
                                "VALUE": {
                                  "block": {
                                    "fields": {
                                      "NUM": 1
                                    },
                                    "id": "`M7g0t=kA8*)XT(*_X3d",
                                    "type": "math_number"
                                  }
                                }
                              },
                              "next": {
                                "block": {
                                  "fields": {
                                    "TYPE": "board",
                                    "VAR": {
                                      "id": ":exT)%gVFw,=tcjABwlL"
                                    }
                                  },
                                  "id": "huGVtvrBW2h,qg,418;2",
                                  "inputs": {
                                    "VALUE": {
                                      "block": {
                                        "fields": {
                                          "NUM": 0
                                        },
                                        "id": "#`_S+~=}l][^r^SHGjb/",
                                        "type": "math_number"
                                      }
                                    }
                                  },
                                  "next": {
                                    "block": {
                                      "fields": {
                                        "TYPE": "board",
                                        "VAR": {
                                          "id": "[pdIt#[(nJ$O}K@.Vx)_"
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
                                                    "NUM": 2700
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
                        "id": "E,S7jUdD`,Xrpu;8:01#",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "NUM": 4
                              },
                              "id": "wxC@n}AF1cQx~YzeQh:;",
                              "type": "math_number"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "OP": "MINUS"
                              },
                              "id": "Y!hBzNHBzB$el-j+%$G5",
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
                                    "id": "j~6(6C5+kFU~}mzgo63s",
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
                                    "id": "wccbiOWIFC?O5)/OizcO",
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
                                  "id": "rh;$L)r%,J*;M9NfCu:J"
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
        "x": 705,
        "y": -2485
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
                                    "id": "7~6|.1yD(Lm9)DNBVA^a"
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
                                "id": "wJOP8/]0tWF;))~f~,Z{",
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
                                                "id": "ec;fD/S5v@$zI1xMqqt`"
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
                                        "NUM": 180
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
                                    "id": "ec;fD/S5v@$zI1xMqqt`"
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
                            "NUM": 1800
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
                              "id": "ec;fD/S5v@$zI1xMqqt`"
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
                            "id": "7xZe}(Wa1TYwf!OP=$5L"
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
                        "id": "#HKZvHB6eMHnmQ_*I6]o",
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
                                        "id": "ec;fD/S5v@$zI1xMqqt`"
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
                          "NUM": 420
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
                "id": "Hy|i.+z;ChBy7?7wO@Yw",
                "inputs": {
                  "DO0": {
                    "block": {
                      "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                      "fields": {
                        "NAME": "boardMethod:AddUnit",
                        "THIS": true
                      },
                      "id": "L:r6Sj7{hB0z!WZ?fq#|",
                      "inputs": {
                        "ARG0": {
                          "block": {
                            "extraState": "<mutation></mutation>",
                            "fields": {
                              "TYPE": "board",
                              "VAR": {
                                "id": "7xZe}(Wa1TYwf!OP=$5L"
                              }
                            },
                            "id": "}#}.iz}t@iFUa}ZUOMu%",
                            "type": "variables_get"
                          }
                        },
                        "ARG1": {
                          "block": {
                            "fields": {
                              "VAR": "Location/SPAWNAREA_MOB_003"
                            },
                            "id": "D#pLSW+;ik#a9(*:mPu#",
                            "type": "stringkeys_get"
                          }
                        },
                        "ARG4": {
                          "block": {
                            "fields": {
                              "NUM": 0
                            },
                            "id": "b~PUVgdmaI8hmfQid/.+",
                            "type": "math_number"
                          }
                        },
                        "ARG5": {
                          "block": {
                            "fields": {
                              "VAR": "Enemy"
                            },
                            "id": "Fk)2Rinl.UnhtA!}aiFe",
                            "type": "teamtag_get"
                          }
                        },
                        "ARG6": {
                          "block": {
                            "fields": {
                              "NUM": 1
                            },
                            "id": "bJE/:)Gb3^;VCx7G!Rdw",
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
                      "id": "_,Cw.@m?!wFw,2/e*y$y",
                      "inputs": {
                        "A": {
                          "block": {
                            "id": "vOi`K1[TH/PWeDFhtF9[",
                            "inputs": {
                              "DIVIDEND": {
                                "block": {
                                  "fields": {
                                    "OP": "MINUS"
                                  },
                                  "id": "(%cL*4+(p_{k_s1DrB`k",
                                  "inputs": {
                                    "A": {
                                      "block": {
                                        "fields": {
                                          "THIS": false,
                                          "VAR": "boardVariable:Tick"
                                        },
                                        "id": "k1k(Nq5I7uS:758AQvWM",
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
                                            "id": "ec;fD/S5v@$zI1xMqqt`"
                                          }
                                        },
                                        "id": "aHrxncLYB`+i0yUL[u[F",
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
                                  "id": "a=$1@f8xGn!M:wMN-p%N",
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
                              "NUM": 450
                            },
                            "id": "!2@x1KqMPUExG)b}nw$,",
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
                    "id": "k,dnkfP(c:+Hgk`Sd~n1",
                    "inputs": {
                      "DO0": {
                        "block": {
                          "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                          "fields": {
                            "NAME": "boardMethod:AddUnit",
                            "THIS": true
                          },
                          "id": "nI%#1sYWEd_`y*{`_Y]#",
                          "inputs": {
                            "ARG0": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "board",
                                  "VAR": {
                                    "id": "8%*=t3%ey;/dhZjEJCTh"
                                  }
                                },
                                "id": ")C0fHG#SoPf5}X}$RAZH",
                                "type": "variables_get"
                              }
                            },
                            "ARG1": {
                              "block": {
                                "fields": {
                                  "VAR": "Location/SPAWNAREA_MOB_003"
                                },
                                "id": "LW4HO|KDQ@x$r_xLNZg6",
                                "type": "stringkeys_get"
                              }
                            },
                            "ARG4": {
                              "block": {
                                "fields": {
                                  "NUM": 0
                                },
                                "id": "WLy1+{AxVBhtBziu4kSZ",
                                "type": "math_number"
                              }
                            },
                            "ARG5": {
                              "block": {
                                "fields": {
                                  "VAR": "Enemy"
                                },
                                "id": "L+E8e$Q;$Q-FEHG=.|E?",
                                "type": "teamtag_get"
                              }
                            },
                            "ARG6": {
                              "block": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "3#[D@4Dun:C6%~JdduEt",
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
                          "id": "U_F$Qe}mPCrAW*neHF7S",
                          "inputs": {
                            "A": {
                              "block": {
                                "id": "Vd:j4OqaDC(V`(xP_vue",
                                "inputs": {
                                  "DIVIDEND": {
                                    "block": {
                                      "fields": {
                                        "OP": "MINUS"
                                      },
                                      "id": "y^.bNK1A.5[75`j^PRP$",
                                      "inputs": {
                                        "A": {
                                          "block": {
                                            "fields": {
                                              "THIS": false,
                                              "VAR": "boardVariable:Tick"
                                            },
                                            "id": "P@9N|PX08E;4|vH_so!l",
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
                                                "id": "ec;fD/S5v@$zI1xMqqt`"
                                              }
                                            },
                                            "id": "ZbCs:`Uoq^ZjrxBd-n7k",
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
                                      "id": "%r[B;Zg0)8#r3lBS$eO-",
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
                                  "NUM": 1020
                                },
                                "id": "v~Vi8vrHU8pU=yVZ:ncT",
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
                        "id": "ZjNR{%0uvQ-=*V.uT*Om",
                        "inputs": {
                          "DO0": {
                            "block": {
                              "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                              "fields": {
                                "NAME": "boardMethod:AddUnit",
                                "THIS": true
                              },
                              "id": "n#I!D|4`du{cwGp2Lvy:",
                              "inputs": {
                                "ARG0": {
                                  "block": {
                                    "extraState": "<mutation></mutation>",
                                    "fields": {
                                      "TYPE": "board",
                                      "VAR": {
                                        "id": "8%*=t3%ey;/dhZjEJCTh"
                                      }
                                    },
                                    "id": "~rl!PP.pxY|PhPs*;;nz",
                                    "type": "variables_get"
                                  }
                                },
                                "ARG1": {
                                  "block": {
                                    "fields": {
                                      "VAR": "Location/SPAWNAREA_MOB_003"
                                    },
                                    "id": "D~Qkl);y2/xgQUD;[i=A",
                                    "type": "stringkeys_get"
                                  }
                                },
                                "ARG4": {
                                  "block": {
                                    "fields": {
                                      "NUM": 0
                                    },
                                    "id": "+,+4zr|y^`5VY^CGbSds",
                                    "type": "math_number"
                                  }
                                },
                                "ARG5": {
                                  "block": {
                                    "fields": {
                                      "VAR": "Enemy"
                                    },
                                    "id": "@u|0OV,l?d@2EQmCM(zP",
                                    "type": "teamtag_get"
                                  }
                                },
                                "ARG6": {
                                  "block": {
                                    "fields": {
                                      "NUM": 1
                                    },
                                    "id": "EH2_h|qJ8)@?!B8LQfU]",
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
                              "id": ":%nI`Z_!T$Up*%{j})q:",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "id": "m=Wmri:H~76nx*?na7Zk",
                                    "inputs": {
                                      "DIVIDEND": {
                                        "block": {
                                          "fields": {
                                            "OP": "MINUS"
                                          },
                                          "id": ".x$O,^CC%I=jAhRgn=z1",
                                          "inputs": {
                                            "A": {
                                              "block": {
                                                "fields": {
                                                  "THIS": false,
                                                  "VAR": "boardVariable:Tick"
                                                },
                                                "id": "v.Q9oY4EWrjZ=f;ENi*_",
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
                                                    "id": "ec;fD/S5v@$zI1xMqqt`"
                                                  }
                                                },
                                                "id": "%9MzbEAD2Dmu;SI3f%PW",
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
                                          "id": "OU}nhRMC7WMoa$9c[4d3",
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
                                      "NUM": 1035
                                    },
                                    "id": "2w@/Aurnz/0YRf^rnj/G",
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
                            "id": "pL1+aEoI{Xb29P7I#tiu",
                            "inputs": {
                              "DO0": {
                                "block": {
                                  "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                  "fields": {
                                    "NAME": "boardMethod:AddUnit",
                                    "THIS": true
                                  },
                                  "id": ";u!wW6]kYPE23rG3svZt",
                                  "inputs": {
                                    "ARG0": {
                                      "block": {
                                        "extraState": "<mutation></mutation>",
                                        "fields": {
                                          "TYPE": "board",
                                          "VAR": {
                                            "id": "8%*=t3%ey;/dhZjEJCTh"
                                          }
                                        },
                                        "id": "%E]hcrOoc92(9iwb?@9@",
                                        "type": "variables_get"
                                      }
                                    },
                                    "ARG1": {
                                      "block": {
                                        "fields": {
                                          "VAR": "Location/SPAWNAREA_MOB_003"
                                        },
                                        "id": "#J*efTD=d1:9o*w$E40G",
                                        "type": "stringkeys_get"
                                      }
                                    },
                                    "ARG4": {
                                      "block": {
                                        "fields": {
                                          "NUM": 0
                                        },
                                        "id": "9(YqFA?qAvB(=r-U~*;R",
                                        "type": "math_number"
                                      }
                                    },
                                    "ARG5": {
                                      "block": {
                                        "fields": {
                                          "VAR": "Enemy"
                                        },
                                        "id": "Y;n%I(,Y|4T?dM~%A9=Y",
                                        "type": "teamtag_get"
                                      }
                                    },
                                    "ARG6": {
                                      "block": {
                                        "fields": {
                                          "NUM": 1
                                        },
                                        "id": "yM=vR]~lSk,+=f28B6k6",
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
                                  "id": "0/ak-#?~$Id2Y7$}!0:C",
                                  "inputs": {
                                    "A": {
                                      "block": {
                                        "id": "MtH(`c6^CcpOzKIeS1b?",
                                        "inputs": {
                                          "DIVIDEND": {
                                            "block": {
                                              "fields": {
                                                "OP": "MINUS"
                                              },
                                              "id": "B[qPD[T5Clt;[X*gEG{C",
                                              "inputs": {
                                                "A": {
                                                  "block": {
                                                    "fields": {
                                                      "THIS": false,
                                                      "VAR": "boardVariable:Tick"
                                                    },
                                                    "id": "bZkNMb;d2[ERqY`n^8(M",
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
                                                        "id": "ec;fD/S5v@$zI1xMqqt`"
                                                      }
                                                    },
                                                    "id": "D5#^+;D3M8fuLPpYW*JS",
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
                                              "id": "D_pt7U]93^L]g^u:|W3v",
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
                                          "NUM": 1050
                                        },
                                        "id": "AP;}dvA!$l:cqi,]CGRr",
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
                                "id": "OjIA}=bu=F4.}+gt,)#N",
                                "inputs": {
                                  "DO0": {
                                    "block": {
                                      "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                      "fields": {
                                        "NAME": "boardMethod:AddUnit",
                                        "THIS": true
                                      },
                                      "id": "*(xD-}hvTJU(j_#IL`_J",
                                      "inputs": {
                                        "ARG0": {
                                          "block": {
                                            "extraState": "<mutation></mutation>",
                                            "fields": {
                                              "TYPE": "board",
                                              "VAR": {
                                                "id": "8%*=t3%ey;/dhZjEJCTh"
                                              }
                                            },
                                            "id": "eE:;iysl3@eSld{Z}SAH",
                                            "type": "variables_get"
                                          }
                                        },
                                        "ARG1": {
                                          "block": {
                                            "fields": {
                                              "VAR": "Location/SPAWNAREA_MOB_003"
                                            },
                                            "id": "rE%4?|$hUX#+qte/_L]`",
                                            "type": "stringkeys_get"
                                          }
                                        },
                                        "ARG4": {
                                          "block": {
                                            "fields": {
                                              "NUM": 0
                                            },
                                            "id": "6~uZf%LV:WjA7XzlrJS}",
                                            "type": "math_number"
                                          }
                                        },
                                        "ARG5": {
                                          "block": {
                                            "fields": {
                                              "VAR": "Enemy"
                                            },
                                            "id": "tL(GcV0XzO}RM]ZYC~dj",
                                            "type": "teamtag_get"
                                          }
                                        },
                                        "ARG6": {
                                          "block": {
                                            "fields": {
                                              "NUM": 1
                                            },
                                            "id": "!WK{Jf~%=vTcU%ZV6=g@",
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
                                      "id": "qN:9NxyO7-cXb(c2*#71",
                                      "inputs": {
                                        "A": {
                                          "block": {
                                            "id": "FuS`krPc2jv,5:Dg;[UL",
                                            "inputs": {
                                              "DIVIDEND": {
                                                "block": {
                                                  "fields": {
                                                    "OP": "MINUS"
                                                  },
                                                  "id": "{:d-gQ;rKJo%{34/1:$c",
                                                  "inputs": {
                                                    "A": {
                                                      "block": {
                                                        "fields": {
                                                          "THIS": false,
                                                          "VAR": "boardVariable:Tick"
                                                        },
                                                        "id": "FijinMhEmP7ft~{b;)Vi",
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
                                                            "id": "ec;fD/S5v@$zI1xMqqt`"
                                                          }
                                                        },
                                                        "id": "udZuDB/M.A6/.@etHs=U",
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
                                                  "id": "sBQ/!-^s(?_*.pDDBU60",
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
                                              "NUM": 1065
                                            },
                                            "id": "-A6*B(EDCU0ogzffWiQf",
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
                                    "id": "35|],[riCB@O!^qa-qdZ",
                                    "inputs": {
                                      "DO0": {
                                        "block": {
                                          "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                          "fields": {
                                            "NAME": "boardMethod:AddUnit",
                                            "THIS": true
                                          },
                                          "id": "UH6p^~`C=w{E/*.C!$j1",
                                          "inputs": {
                                            "ARG0": {
                                              "block": {
                                                "extraState": "<mutation></mutation>",
                                                "fields": {
                                                  "TYPE": "board",
                                                  "VAR": {
                                                    "id": "|G$vuKLRm!2axX$G84W%"
                                                  }
                                                },
                                                "id": "pxX|^Rd8ie(97E4sP[qB",
                                                "type": "variables_get"
                                              }
                                            },
                                            "ARG1": {
                                              "block": {
                                                "fields": {
                                                  "VAR": "Location/SPAWNAREA_MOB_003"
                                                },
                                                "id": "qUTQhWw1WktB2;7#J!-L",
                                                "type": "stringkeys_get"
                                              }
                                            },
                                            "ARG4": {
                                              "block": {
                                                "fields": {
                                                  "NUM": 0
                                                },
                                                "id": "{3?(Fx_VM`h(aF`2fePK",
                                                "type": "math_number"
                                              }
                                            },
                                            "ARG5": {
                                              "block": {
                                                "fields": {
                                                  "VAR": "Enemy"
                                                },
                                                "id": "fkA|?58P##2*pRg$$6,{",
                                                "type": "teamtag_get"
                                              }
                                            },
                                            "ARG6": {
                                              "block": {
                                                "fields": {
                                                  "NUM": 1
                                                },
                                                "id": ",fSHj!x0d5OI)RihS^lt",
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
                                          "id": "_qV)p|*$(EG5`hfT2Lsq",
                                          "inputs": {
                                            "A": {
                                              "block": {
                                                "id": "*VRN@$wk/xahaj/k?Op:",
                                                "inputs": {
                                                  "DIVIDEND": {
                                                    "block": {
                                                      "fields": {
                                                        "OP": "MINUS"
                                                      },
                                                      "id": "O;OI=jGozNb?h.,3L0R?",
                                                      "inputs": {
                                                        "A": {
                                                          "block": {
                                                            "fields": {
                                                              "THIS": false,
                                                              "VAR": "boardVariable:Tick"
                                                            },
                                                            "id": "`#`Pfa#G*ukH6Y.7YKRl",
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
                                                                "id": "ec;fD/S5v@$zI1xMqqt`"
                                                              }
                                                            },
                                                            "id": "SLBm5udB_,S7.m!H(fC@",
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
                                                      "id": "FTJ$Y_$j`2RmoRlBGazI",
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
                                                  "NUM": 1335
                                                },
                                                "id": "AhA7VPU[nONX_;Q-UavZ",
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
                                        "id": "..U{_qtS+-+aw9D%Z?[d",
                                        "inputs": {
                                          "DO0": {
                                            "block": {
                                              "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                              "fields": {
                                                "NAME": "boardMethod:AddUnit",
                                                "THIS": true
                                              },
                                              "id": "_{Ll~MlbD?-LNCll}4H?",
                                              "inputs": {
                                                "ARG0": {
                                                  "block": {
                                                    "extraState": "<mutation></mutation>",
                                                    "fields": {
                                                      "TYPE": "board",
                                                      "VAR": {
                                                        "id": "7~6|.1yD(Lm9)DNBVA^a"
                                                      }
                                                    },
                                                    "id": "mQoq|LUuF,caM@Z,M?Yt",
                                                    "type": "variables_get"
                                                  }
                                                },
                                                "ARG1": {
                                                  "block": {
                                                    "fields": {
                                                      "VAR": "Location/SPAWNAREA_MOB_003"
                                                    },
                                                    "id": "VaBdx#Pkil)Z7_n4zi,]",
                                                    "type": "stringkeys_get"
                                                  }
                                                },
                                                "ARG4": {
                                                  "block": {
                                                    "fields": {
                                                      "NUM": 0
                                                    },
                                                    "id": "h-|0w#MF;GnD1VeT+9MK",
                                                    "type": "math_number"
                                                  }
                                                },
                                                "ARG5": {
                                                  "block": {
                                                    "fields": {
                                                      "VAR": "Enemy"
                                                    },
                                                    "id": "XE?^,y5UYfpdN0%?X,-)",
                                                    "type": "teamtag_get"
                                                  }
                                                },
                                                "ARG6": {
                                                  "block": {
                                                    "fields": {
                                                      "NUM": 1
                                                    },
                                                    "id": "KJ#IKT}NIP51pjTH$T;k",
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
                                              "id": "(ntPlx[h1g?nP6E}k2(s",
                                              "inputs": {
                                                "A": {
                                                  "block": {
                                                    "id": "XiHU+!TV#h(+onOw+aoc",
                                                    "inputs": {
                                                      "DIVIDEND": {
                                                        "block": {
                                                          "fields": {
                                                            "OP": "MINUS"
                                                          },
                                                          "id": "EaNWT$[LNTc*]/v~+Ffn",
                                                          "inputs": {
                                                            "A": {
                                                              "block": {
                                                                "fields": {
                                                                  "THIS": false,
                                                                  "VAR": "boardVariable:Tick"
                                                                },
                                                                "id": "{*Uc`9b-S~SO+.miRCFG",
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
                                                                    "id": "ec;fD/S5v@$zI1xMqqt`"
                                                                  }
                                                                },
                                                                "id": "}?Qo9z2aFM,qT!JK/a$R",
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
                                                          "id": "/eWol2T7g1}A%7RHC@/I",
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
                                                    "id": ";KW9_2g}j_.?RL7.,P+|",
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
                                            "id": "*}s}b}u8GAG*tBrCI~FW",
                                            "inputs": {
                                              "DO0": {
                                                "block": {
                                                  "id": "K0`S?.rn[1sb4G_@#IWy",
                                                  "inputs": {
                                                    "DO0": {
                                                      "block": {
                                                        "id": "#it_hWAsl:!Q0!U#41s@",
                                                        "inputs": {
                                                          "DO0": {
                                                            "block": {
                                                              "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                              "fields": {
                                                                "NAME": "boardMethod:AddUnit",
                                                                "THIS": true
                                                              },
                                                              "id": "]k{Um3xx_Z}N/y8hQ|kc",
                                                              "inputs": {
                                                                "ARG0": {
                                                                  "block": {
                                                                    "extraState": "<mutation></mutation>",
                                                                    "fields": {
                                                                      "TYPE": "board",
                                                                      "VAR": {
                                                                        "id": "7~6|.1yD(Lm9)DNBVA^a"
                                                                      }
                                                                    },
                                                                    "id": "S^`p#$$d}BVPOG!9pZlx",
                                                                    "type": "variables_get"
                                                                  }
                                                                },
                                                                "ARG1": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "VAR": "Location/SPAWNAREA_MOB_003"
                                                                    },
                                                                    "id": "5G0h18s69smJQ=.GH=nr",
                                                                    "type": "stringkeys_get"
                                                                  }
                                                                },
                                                                "ARG4": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "NUM": 0
                                                                    },
                                                                    "id": "Xwt^pVAI}(VMpPc/|f81",
                                                                    "type": "math_number"
                                                                  }
                                                                },
                                                                "ARG5": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "VAR": "Enemy"
                                                                    },
                                                                    "id": "k]HPX@s)ssXwG0PeskS!",
                                                                    "type": "teamtag_get"
                                                                  }
                                                                },
                                                                "ARG6": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "NUM": 1
                                                                    },
                                                                    "id": "VC_cHKVm,842U$[7uJI9",
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
                                                              "id": "6]S#.z^uaOYjLTV{b~[a",
                                                              "inputs": {
                                                                "A": {
                                                                  "block": {
                                                                    "id": "Dtx(LOcSnLU(Mb3TzJ_B",
                                                                    "inputs": {
                                                                      "DIVIDEND": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "OP": "MINUS"
                                                                          },
                                                                          "id": "sK*.yB#D[*zPw^%F{+%e",
                                                                          "inputs": {
                                                                            "A": {
                                                                              "block": {
                                                                                "fields": {
                                                                                  "THIS": false,
                                                                                  "VAR": "boardVariable:Tick"
                                                                                },
                                                                                "id": "m1ui-JET7%#DUUen[V*W",
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
                                                                                    "id": "ec;fD/S5v@$zI1xMqqt`"
                                                                                  }
                                                                                },
                                                                                "id": "3Fktu8:Bh}bM~f`%(FD!",
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
                                                                            "NUM": 180
                                                                          },
                                                                          "id": "8hy(q8FUg-A$qfhb[s3a",
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
                                                                      "NUM": 150
                                                                    },
                                                                    "id": "LYhp_HUuj7BkOLSdk-nD",
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
                                                        "id": "FkIQIx/Q6D`@RipQC:hy",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "fields": {
                                                                "OP": "MINUS"
                                                              },
                                                              "id": "AruI$40a5|#xp$~2pj6q",
                                                              "inputs": {
                                                                "A": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "THIS": false,
                                                                      "VAR": "boardVariable:Tick"
                                                                    },
                                                                    "id": "nbeCvLp4*za~*e[,,`q{",
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
                                                                        "id": "ec;fD/S5v@$zI1xMqqt`"
                                                                      }
                                                                    },
                                                                    "id": "O_hU[n3;N?R@y6H$J0de",
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
                                                                "NUM": 2340
                                                              },
                                                              "id": "qgUpL7YOMP2UG5Hu@^]v",
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
                                                  "id": "!?Pd4rg]^|a.0LS)KoeO",
                                                  "inputs": {
                                                    "A": {
                                                      "block": {
                                                        "fields": {
                                                          "OP": "MINUS"
                                                        },
                                                        "id": "z-UWw-*GOnB5K6YS//eu",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "fields": {
                                                                "THIS": false,
                                                                "VAR": "boardVariable:Tick"
                                                              },
                                                              "id": "tXN#Pd#[D]}qdZd#ddt,",
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
                                                                  "id": "ec;fD/S5v@$zI1xMqqt`"
                                                                }
                                                              },
                                                              "id": "1E?yS}+Jd=p-hfP]B^ag",
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
                                                          "NUM": 1950
                                                        },
                                                        "id": "8F8m).=NP*#XfQ^^DhLG",
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
                                                "id": "7bo_%c7QN%q}u;5%wx[,",
                                                "inputs": {
                                                  "DO0": {
                                                    "block": {
                                                      "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                      "fields": {
                                                        "NAME": "boardMethod:AddUnit",
                                                        "THIS": true
                                                      },
                                                      "id": "V`i}a_}(|VSwB6_OiI[X",
                                                      "inputs": {
                                                        "ARG0": {
                                                          "block": {
                                                            "extraState": "<mutation></mutation>",
                                                            "fields": {
                                                              "TYPE": "board",
                                                              "VAR": {
                                                                "id": "|G$vuKLRm!2axX$G84W%"
                                                              }
                                                            },
                                                            "id": "Lgih8`%D?FG.?3YoL}?t",
                                                            "type": "variables_get"
                                                          }
                                                        },
                                                        "ARG1": {
                                                          "block": {
                                                            "fields": {
                                                              "VAR": "Location/SPAWNAREA_MOB_003"
                                                            },
                                                            "id": "Ev-w:XJf2MI+h/)j0!wx",
                                                            "type": "stringkeys_get"
                                                          }
                                                        },
                                                        "ARG4": {
                                                          "block": {
                                                            "fields": {
                                                              "NUM": 0
                                                            },
                                                            "id": "0)M/lsE#b%e5wP3sbv8q",
                                                            "type": "math_number"
                                                          }
                                                        },
                                                        "ARG5": {
                                                          "block": {
                                                            "fields": {
                                                              "VAR": "Enemy"
                                                            },
                                                            "id": "5MW!Qc(BnX!mB*VGnSIG",
                                                            "type": "teamtag_get"
                                                          }
                                                        },
                                                        "ARG6": {
                                                          "block": {
                                                            "fields": {
                                                              "NUM": 1
                                                            },
                                                            "id": "6t76dlzFN{lixy+4[Kkc",
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
                                                      "id": "eGhg{cCr0H,1J:;(w|~0",
                                                      "inputs": {
                                                        "A": {
                                                          "block": {
                                                            "id": "1y.6CJshb?ypup~?Q]_H",
                                                            "inputs": {
                                                              "DIVIDEND": {
                                                                "block": {
                                                                  "fields": {
                                                                    "OP": "MINUS"
                                                                  },
                                                                  "id": "%+=YC+*,n9zZIWp$39w+",
                                                                  "inputs": {
                                                                    "A": {
                                                                      "block": {
                                                                        "fields": {
                                                                          "THIS": false,
                                                                          "VAR": "boardVariable:Tick"
                                                                        },
                                                                        "id": ".4SdSV375@(n=t!aBB7l",
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
                                                                            "id": "ec;fD/S5v@$zI1xMqqt`"
                                                                          }
                                                                        },
                                                                        "id": "(zOd~C3*z.dT6BR2H(Pu",
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
                                                                  "id": "r_ZIic!GoAZiZ[:nS:Om",
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
                                                              "NUM": 1980
                                                            },
                                                            "id": "/bAvr^X:*z+:CAA#JXYv",
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
                                                    "id": "iCc98xFxIytaI3H9t9$Z",
                                                    "inputs": {
                                                      "DO0": {
                                                        "block": {
                                                          "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                          "fields": {
                                                            "NAME": "boardMethod:AddUnit",
                                                            "THIS": true
                                                          },
                                                          "id": "q+_Q$V49tayV/h/j=}NV",
                                                          "inputs": {
                                                            "ARG0": {
                                                              "block": {
                                                                "extraState": "<mutation></mutation>",
                                                                "fields": {
                                                                  "TYPE": "board",
                                                                  "VAR": {
                                                                    "id": "8%*=t3%ey;/dhZjEJCTh"
                                                                  }
                                                                },
                                                                "id": "O-@sDC5fEc9Lp)R|7F1V",
                                                                "type": "variables_get"
                                                              }
                                                            },
                                                            "ARG1": {
                                                              "block": {
                                                                "fields": {
                                                                  "VAR": "Location/SPAWNAREA_MOB_003"
                                                                },
                                                                "id": "70|m4$4BGx8$[OW1L[6p",
                                                                "type": "stringkeys_get"
                                                              }
                                                            },
                                                            "ARG4": {
                                                              "block": {
                                                                "fields": {
                                                                  "NUM": 0
                                                                },
                                                                "id": "27lP%0i!)smgD5vXu4zG",
                                                                "type": "math_number"
                                                              }
                                                            },
                                                            "ARG5": {
                                                              "block": {
                                                                "fields": {
                                                                  "VAR": "Enemy"
                                                                },
                                                                "id": "~qRzFu#8dQK^O?Qrrv.Y",
                                                                "type": "teamtag_get"
                                                              }
                                                            },
                                                            "ARG6": {
                                                              "block": {
                                                                "fields": {
                                                                  "NUM": 1
                                                                },
                                                                "id": "Ps^ckm5CzYU;P2fdk8~v",
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
                                                          "id": "zNU6Q$zRDA0dt/VwCl#y",
                                                          "inputs": {
                                                            "A": {
                                                              "block": {
                                                                "id": "oK+?wm:ZGzKKH#y6,hCD",
                                                                "inputs": {
                                                                  "DIVIDEND": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "OP": "MINUS"
                                                                      },
                                                                      "id": "`-Sk.~u_8ii(zy%:]]s,",
                                                                      "inputs": {
                                                                        "A": {
                                                                          "block": {
                                                                            "fields": {
                                                                              "THIS": false,
                                                                              "VAR": "boardVariable:Tick"
                                                                            },
                                                                            "id": "hUQ7^(*!hV,/`0:4z@#I",
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
                                                                                "id": "ec;fD/S5v@$zI1xMqqt`"
                                                                              }
                                                                            },
                                                                            "id": "FhmBCM-;nyEcTXt|u$X5",
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
                                                                      "id": "cZgG:Dg?jn|PZEl?gX=b",
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
                                                                  "NUM": 2355
                                                                },
                                                                "id": "5Azfn5KiSEFCjx!r6t*Z",
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
                                                        "id": "D2~.^u7QpH_hk:w}i3]_",
                                                        "inputs": {
                                                          "DO0": {
                                                            "block": {
                                                              "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                              "fields": {
                                                                "NAME": "boardMethod:AddUnit",
                                                                "THIS": true
                                                              },
                                                              "id": "fCn1#qMRVxB`2FPta:[M",
                                                              "inputs": {
                                                                "ARG0": {
                                                                  "block": {
                                                                    "extraState": "<mutation></mutation>",
                                                                    "fields": {
                                                                      "TYPE": "board",
                                                                      "VAR": {
                                                                        "id": "8%*=t3%ey;/dhZjEJCTh"
                                                                      }
                                                                    },
                                                                    "id": "3RS6qk0INNbO97f$#Y6I",
                                                                    "type": "variables_get"
                                                                  }
                                                                },
                                                                "ARG1": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "VAR": "Location/SPAWNAREA_MOB_003"
                                                                    },
                                                                    "id": "4q[l`/w#;jERW:|]nbbr",
                                                                    "type": "stringkeys_get"
                                                                  }
                                                                },
                                                                "ARG4": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "NUM": 0
                                                                    },
                                                                    "id": "=?n9ll[Zglpy8;v$:;5V",
                                                                    "type": "math_number"
                                                                  }
                                                                },
                                                                "ARG5": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "VAR": "Enemy"
                                                                    },
                                                                    "id": "JK9M0IU%%:#s{w6_w5?1",
                                                                    "type": "teamtag_get"
                                                                  }
                                                                },
                                                                "ARG6": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "NUM": 1
                                                                    },
                                                                    "id": "9^]wG%j1VrhrDOu{8RUu",
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
                                                              "id": "),[np;;GTN7hwR?FB4i+",
                                                              "inputs": {
                                                                "A": {
                                                                  "block": {
                                                                    "id": "SGArtR^b;!x/7q`#gs)/",
                                                                    "inputs": {
                                                                      "DIVIDEND": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "OP": "MINUS"
                                                                          },
                                                                          "id": "os|o)Y)!jmBNNS9:_Jo=",
                                                                          "inputs": {
                                                                            "A": {
                                                                              "block": {
                                                                                "fields": {
                                                                                  "THIS": false,
                                                                                  "VAR": "boardVariable:Tick"
                                                                                },
                                                                                "id": "[F{D5Vx5E+dm6GH_YwQA",
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
                                                                                    "id": "ec;fD/S5v@$zI1xMqqt`"
                                                                                  }
                                                                                },
                                                                                "id": "~$}hx7]]ihJ5oKt.6-~U",
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
                                                                          "id": "!+bw/qm*/=$9@r~}g?T5",
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
                                                                      "NUM": 2370
                                                                    },
                                                                    "id": "AhQt.4N`Jk_vHFjeod@c",
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
                                                            "id": "!Y9|twN?7DTpNq_.?j?u",
                                                            "inputs": {
                                                              "DO0": {
                                                                "block": {
                                                                  "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                                  "fields": {
                                                                    "NAME": "boardMethod:AddUnit",
                                                                    "THIS": true
                                                                  },
                                                                  "id": "N@fA0]?OnWar3U*wAn27",
                                                                  "inputs": {
                                                                    "ARG0": {
                                                                      "block": {
                                                                        "extraState": "<mutation></mutation>",
                                                                        "fields": {
                                                                          "TYPE": "board",
                                                                          "VAR": {
                                                                            "id": "8%*=t3%ey;/dhZjEJCTh"
                                                                          }
                                                                        },
                                                                        "id": "b2AE=TKkF?Oe]kL?Oq{v",
                                                                        "type": "variables_get"
                                                                      }
                                                                    },
                                                                    "ARG1": {
                                                                      "block": {
                                                                        "fields": {
                                                                          "VAR": "Location/SPAWNAREA_MOB_003"
                                                                        },
                                                                        "id": "{_/qsZX(}1bWsW1[Aa@.",
                                                                        "type": "stringkeys_get"
                                                                      }
                                                                    },
                                                                    "ARG4": {
                                                                      "block": {
                                                                        "fields": {
                                                                          "NUM": 0
                                                                        },
                                                                        "id": "eEJV4lC8fKJZ^DtJ,8Yn",
                                                                        "type": "math_number"
                                                                      }
                                                                    },
                                                                    "ARG5": {
                                                                      "block": {
                                                                        "fields": {
                                                                          "VAR": "Enemy"
                                                                        },
                                                                        "id": "o$s?21A9-FAi6dmkyxWb",
                                                                        "type": "teamtag_get"
                                                                      }
                                                                    },
                                                                    "ARG6": {
                                                                      "block": {
                                                                        "fields": {
                                                                          "NUM": 1
                                                                        },
                                                                        "id": "WI%=z.Q?f/t1=R5w6P__",
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
                                                                  "id": "!a2Sek-?R;NAfQr!q;p/",
                                                                  "inputs": {
                                                                    "A": {
                                                                      "block": {
                                                                        "id": "iga#B:?#J#F09%74~t:D",
                                                                        "inputs": {
                                                                          "DIVIDEND": {
                                                                            "block": {
                                                                              "fields": {
                                                                                "OP": "MINUS"
                                                                              },
                                                                              "id": "|k|9pA2704xxBn|7p*`u",
                                                                              "inputs": {
                                                                                "A": {
                                                                                  "block": {
                                                                                    "fields": {
                                                                                      "THIS": false,
                                                                                      "VAR": "boardVariable:Tick"
                                                                                    },
                                                                                    "id": "gE;!Yl1s!Ul#Ef*c8K=[",
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
                                                                                        "id": "ec;fD/S5v@$zI1xMqqt`"
                                                                                      }
                                                                                    },
                                                                                    "id": "[|rgK]XVALCx*dO|6bb(",
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
                                                                              "id": "K_6S[L@{JE84{lb`%R$.",
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
                                                                          "NUM": 2385
                                                                        },
                                                                        "id": "|K=BmTeG(OWd`Y_Ygs+g",
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
                                                                "id": "xx6DtsD/-K@T]?k[R+1m",
                                                                "inputs": {
                                                                  "DO0": {
                                                                    "block": {
                                                                      "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                                      "fields": {
                                                                        "NAME": "boardMethod:AddUnit",
                                                                        "THIS": true
                                                                      },
                                                                      "id": "QJn=?T=UV)jw0(Rn=i=1",
                                                                      "inputs": {
                                                                        "ARG0": {
                                                                          "block": {
                                                                            "extraState": "<mutation></mutation>",
                                                                            "fields": {
                                                                              "TYPE": "board",
                                                                              "VAR": {
                                                                                "id": "7xZe}(Wa1TYwf!OP=$5L"
                                                                              }
                                                                            },
                                                                            "id": "a19:0mzyo}f@QSy[pe-k",
                                                                            "type": "variables_get"
                                                                          }
                                                                        },
                                                                        "ARG1": {
                                                                          "block": {
                                                                            "fields": {
                                                                              "VAR": "Location/SPAWNAREA_MOB_003"
                                                                            },
                                                                            "id": "T-o}z*5FJqgGeKV[j[0*",
                                                                            "type": "stringkeys_get"
                                                                          }
                                                                        },
                                                                        "ARG4": {
                                                                          "block": {
                                                                            "fields": {
                                                                              "NUM": 0
                                                                            },
                                                                            "id": ")h@{XT:/zm~IZ[UqTO=X",
                                                                            "type": "math_number"
                                                                          }
                                                                        },
                                                                        "ARG5": {
                                                                          "block": {
                                                                            "fields": {
                                                                              "VAR": "Enemy"
                                                                            },
                                                                            "id": "dE/dj-otfM?q9nxz@r0t",
                                                                            "type": "teamtag_get"
                                                                          }
                                                                        },
                                                                        "ARG6": {
                                                                          "block": {
                                                                            "fields": {
                                                                              "NUM": 1
                                                                            },
                                                                            "id": "@+mDzEX|!+kYr^X2q?Oj",
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
                                                                      "id": "._dhq`$$^f)M,+x!v0J!",
                                                                      "inputs": {
                                                                        "A": {
                                                                          "block": {
                                                                            "id": "8dtYY{Us[;_~GS1-g}C#",
                                                                            "inputs": {
                                                                              "DIVIDEND": {
                                                                                "block": {
                                                                                  "fields": {
                                                                                    "OP": "MINUS"
                                                                                  },
                                                                                  "id": "}s!nfr}CPA0]Ri2ITzi]",
                                                                                  "inputs": {
                                                                                    "A": {
                                                                                      "block": {
                                                                                        "fields": {
                                                                                          "THIS": false,
                                                                                          "VAR": "boardVariable:Tick"
                                                                                        },
                                                                                        "id": "m{HrGd,[IEDMz~iJv]W?",
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
                                                                                            "id": "ec;fD/S5v@$zI1xMqqt`"
                                                                                          }
                                                                                        },
                                                                                        "id": "_h~IhxG-VKsmqZrMh6Z3",
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
                                                                                  "id": "SNYxqtpkW0IaR)4Xk!|s",
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
                                                                              "NUM": 2385
                                                                            },
                                                                            "id": "7Mw]ZT$`EGe;}rXo}D;V",
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
                                                                    "id": "e10A9[faeD9Wh#tNc.lY",
                                                                    "inputs": {
                                                                      "DO0": {
                                                                        "block": {
                                                                          "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                                          "fields": {
                                                                            "NAME": "boardMethod:AddUnit",
                                                                            "THIS": true
                                                                          },
                                                                          "id": "%(?TxCbf{g58DFkj~7S+",
                                                                          "inputs": {
                                                                            "ARG0": {
                                                                              "block": {
                                                                                "extraState": "<mutation></mutation>",
                                                                                "fields": {
                                                                                  "TYPE": "board",
                                                                                  "VAR": {
                                                                                    "id": "7xZe}(Wa1TYwf!OP=$5L"
                                                                                  }
                                                                                },
                                                                                "id": "Y2Y3Av9G7bnQ?7SYG~{W",
                                                                                "type": "variables_get"
                                                                              }
                                                                            },
                                                                            "ARG1": {
                                                                              "block": {
                                                                                "fields": {
                                                                                  "VAR": "Location/SPAWNAREA_MOB_003"
                                                                                },
                                                                                "id": "w3O=_0J5s!L{qC{QJWqV",
                                                                                "type": "stringkeys_get"
                                                                              }
                                                                            },
                                                                            "ARG4": {
                                                                              "block": {
                                                                                "fields": {
                                                                                  "NUM": 0
                                                                                },
                                                                                "id": "I?da@yyhiqdYzZh[+smm",
                                                                                "type": "math_number"
                                                                              }
                                                                            },
                                                                            "ARG5": {
                                                                              "block": {
                                                                                "fields": {
                                                                                  "VAR": "Enemy"
                                                                                },
                                                                                "id": "UK{jm}7s*}Kyp1u)sm3R",
                                                                                "type": "teamtag_get"
                                                                              }
                                                                            },
                                                                            "ARG6": {
                                                                              "block": {
                                                                                "fields": {
                                                                                  "NUM": 1
                                                                                },
                                                                                "id": "6NG;BwRSM^LYvOa=G7Ng",
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
                                                                          "id": "[MErFkOgpF+MQoX1.w/*",
                                                                          "inputs": {
                                                                            "A": {
                                                                              "block": {
                                                                                "id": "xjbU6SdqpLiQK+~e7n(+",
                                                                                "inputs": {
                                                                                  "DIVIDEND": {
                                                                                    "block": {
                                                                                      "fields": {
                                                                                        "OP": "MINUS"
                                                                                      },
                                                                                      "id": "]1K]=c,BVFe^5).4kAQf",
                                                                                      "inputs": {
                                                                                        "A": {
                                                                                          "block": {
                                                                                            "fields": {
                                                                                              "THIS": false,
                                                                                              "VAR": "boardVariable:Tick"
                                                                                            },
                                                                                            "id": "Q*{|hgNG:17nTa;3d!nT",
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
                                                                                                "id": "ec;fD/S5v@$zI1xMqqt`"
                                                                                              }
                                                                                            },
                                                                                            "id": "!77c81gq;4fu`kJUJ1E5",
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
                                                                                      "id": "eWs.[KJU=RbFUcSxuBjd",
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
                                                                                  "NUM": 2400
                                                                                },
                                                                                "id": "[6v@b[EiICf(2?2-B^mQ",
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
                                                                        "id": "~sUu502=fXBBcHE17tv-",
                                                                        "inputs": {
                                                                          "DO0": {
                                                                            "block": {
                                                                              "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                                              "fields": {
                                                                                "NAME": "boardMethod:AddUnit",
                                                                                "THIS": true
                                                                              },
                                                                              "id": "m80`#KwQ(cHyTcu@IwO%",
                                                                              "inputs": {
                                                                                "ARG0": {
                                                                                  "block": {
                                                                                    "extraState": "<mutation></mutation>",
                                                                                    "fields": {
                                                                                      "TYPE": "board",
                                                                                      "VAR": {
                                                                                        "id": "7~6|.1yD(Lm9)DNBVA^a"
                                                                                      }
                                                                                    },
                                                                                    "id": "wG[=77^3_[DNR1enC;m{",
                                                                                    "type": "variables_get"
                                                                                  }
                                                                                },
                                                                                "ARG1": {
                                                                                  "block": {
                                                                                    "fields": {
                                                                                      "VAR": "Location/SPAWNAREA_MOB_003"
                                                                                    },
                                                                                    "id": "zwP9LV87%gl8nV4nGWId",
                                                                                    "type": "stringkeys_get"
                                                                                  }
                                                                                },
                                                                                "ARG4": {
                                                                                  "block": {
                                                                                    "fields": {
                                                                                      "NUM": 0
                                                                                    },
                                                                                    "id": "y@R:D%x9YzUEJx]WiZa2",
                                                                                    "type": "math_number"
                                                                                  }
                                                                                },
                                                                                "ARG5": {
                                                                                  "block": {
                                                                                    "fields": {
                                                                                      "VAR": "Enemy"
                                                                                    },
                                                                                    "id": "~{OjiWS3[=;I7!Hd.oVI",
                                                                                    "type": "teamtag_get"
                                                                                  }
                                                                                },
                                                                                "ARG6": {
                                                                                  "block": {
                                                                                    "fields": {
                                                                                      "NUM": 1
                                                                                    },
                                                                                    "id": "+^-}s$iVFQs2YkG(X[kK",
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
                                                                              "id": "cXwhZswtjvHF9A*[dPhR",
                                                                              "inputs": {
                                                                                "A": {
                                                                                  "block": {
                                                                                    "id": "w_NdxTOx/YZ.YU=,MXhV",
                                                                                    "inputs": {
                                                                                      "DIVIDEND": {
                                                                                        "block": {
                                                                                          "fields": {
                                                                                            "OP": "MINUS"
                                                                                          },
                                                                                          "id": "F?B=S9QF)C~.Ej$W+wd^",
                                                                                          "inputs": {
                                                                                            "A": {
                                                                                              "block": {
                                                                                                "fields": {
                                                                                                  "THIS": false,
                                                                                                  "VAR": "boardVariable:Tick"
                                                                                                },
                                                                                                "id": "|-XZ-,b^B/dV;Ycfux*d",
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
                                                                                                    "id": "ec;fD/S5v@$zI1xMqqt`"
                                                                                                  }
                                                                                                },
                                                                                                "id": "wttKSCjZNOMxBrsl6xTG",
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
                                                                                          "id": "vwXZPB3Tqh0T%|eC)GyD",
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
                                                                                      "NUM": 2640
                                                                                    },
                                                                                    "id": "@(mz4Oo4,nqFd}8k*{:q",
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
                                                                            "id": "(ttw2wqdOL_RNimdN[Q+",
                                                                            "inputs": {
                                                                              "DO0": {
                                                                                "block": {
                                                                                  "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                                                  "fields": {
                                                                                    "NAME": "boardMethod:AddUnit",
                                                                                    "THIS": true
                                                                                  },
                                                                                  "id": "8$l@37O|:.w7fWTLWI)1",
                                                                                  "inputs": {
                                                                                    "ARG0": {
                                                                                      "block": {
                                                                                        "extraState": "<mutation></mutation>",
                                                                                        "fields": {
                                                                                          "TYPE": "board",
                                                                                          "VAR": {
                                                                                            "id": "7~6|.1yD(Lm9)DNBVA^a"
                                                                                          }
                                                                                        },
                                                                                        "id": ")otlW.Q!ZUe}Fzds7J|#",
                                                                                        "type": "variables_get"
                                                                                      }
                                                                                    },
                                                                                    "ARG1": {
                                                                                      "block": {
                                                                                        "fields": {
                                                                                          "VAR": "Location/SPAWNAREA_MOB_003"
                                                                                        },
                                                                                        "id": "I]QvxU:6#(PKx7:W%PE{",
                                                                                        "type": "stringkeys_get"
                                                                                      }
                                                                                    },
                                                                                    "ARG4": {
                                                                                      "block": {
                                                                                        "fields": {
                                                                                          "NUM": 0
                                                                                        },
                                                                                        "id": "L$osa.BxSSm+O{1G0P@7",
                                                                                        "type": "math_number"
                                                                                      }
                                                                                    },
                                                                                    "ARG5": {
                                                                                      "block": {
                                                                                        "fields": {
                                                                                          "VAR": "Enemy"
                                                                                        },
                                                                                        "id": "Gq3l1:V;CoE3DM]dkD.E",
                                                                                        "type": "teamtag_get"
                                                                                      }
                                                                                    },
                                                                                    "ARG6": {
                                                                                      "block": {
                                                                                        "fields": {
                                                                                          "NUM": 1
                                                                                        },
                                                                                        "id": "IBH=A4T1AYi5Us_|_FZ;",
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
                                                                                  "id": "gL[|v/BlW7d5sklv)]2_",
                                                                                  "inputs": {
                                                                                    "A": {
                                                                                      "block": {
                                                                                        "id": "?y8dkPIN(c=U2:K^SGF)",
                                                                                        "inputs": {
                                                                                          "DIVIDEND": {
                                                                                            "block": {
                                                                                              "fields": {
                                                                                                "OP": "MINUS"
                                                                                              },
                                                                                              "id": "0_;,W)rt1CGq^aksJS=?",
                                                                                              "inputs": {
                                                                                                "A": {
                                                                                                  "block": {
                                                                                                    "fields": {
                                                                                                      "THIS": false,
                                                                                                      "VAR": "boardVariable:Tick"
                                                                                                    },
                                                                                                    "id": "?a-{=%cw4^u49WJ`L@n#",
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
                                                                                                        "id": "ec;fD/S5v@$zI1xMqqt`"
                                                                                                      }
                                                                                                    },
                                                                                                    "id": "2rqn:eCe(B@vGDA?e[L$",
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
                                                                                              "id": ":-1UKpUrG;H%rrBMiP{}",
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
                                                                                          "NUM": 2655
                                                                                        },
                                                                                        "id": "C!r+hvJHVEM~`cFzzi_Q",
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
                                                                                "id": "B+Gr)ddAjW]fPCX##Of9",
                                                                                "inputs": {
                                                                                  "DO0": {
                                                                                    "block": {
                                                                                      "fields": {
                                                                                        "TYPE": "board",
                                                                                        "VAR": {
                                                                                          "id": ":exT)%gVFw,=tcjABwlL"
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
                                                                                          "fields": {
                                                                                            "NAME": "Log"
                                                                                          },
                                                                                          "id": "Z8(s?-HahSCgJUz%c(vV",
                                                                                          "inputs": {
                                                                                            "TEXT": {
                                                                                              "block": {
                                                                                                "fields": {
                                                                                                  "TEXT": "Boss spawn!"
                                                                                                },
                                                                                                "id": ";ocP${_8#yX(iUAy3mQM",
                                                                                                "type": "text"
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
                                                                                              "id": "yE5zA1JQ:[`w.[1;HZ{M",
                                                                                              "inputs": {
                                                                                                "ARG0": {
                                                                                                  "block": {
                                                                                                    "extraState": "<mutation></mutation>",
                                                                                                    "fields": {
                                                                                                      "TYPE": "board",
                                                                                                      "VAR": {
                                                                                                        "id": "P^p4QD$I*Br|L316}YTn"
                                                                                                      }
                                                                                                    },
                                                                                                    "id": "uEf/Z#?`b6+!g`!+[C-j",
                                                                                                    "type": "variables_get"
                                                                                                  }
                                                                                                },
                                                                                                "ARG1": {
                                                                                                  "block": {
                                                                                                    "fields": {
                                                                                                      "VAR": "Location/SPAWNAREA_MOB_003"
                                                                                                    },
                                                                                                    "id": "%rkr?jbN[OO-e^8ZyZ#o",
                                                                                                    "type": "stringkeys_get"
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
                                                                                                      "id": "fDexjWy[wSL[f[20TBS*"
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
                                                                                                  "type": "variables_set"
                                                                                                }
                                                                                              },
                                                                                              "type": "function_call"
                                                                                            }
                                                                                          },
                                                                                          "type": "debug"
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
                                                                                      "id": ";%F%|BT$Vv?,:P[6{(K0",
                                                                                      "inputs": {
                                                                                        "A": {
                                                                                          "block": {
                                                                                            "id": "fO!dW,a?0_QGwJQrRXID",
                                                                                            "inputs": {
                                                                                              "DIVIDEND": {
                                                                                                "block": {
                                                                                                  "fields": {
                                                                                                    "OP": "MINUS"
                                                                                                  },
                                                                                                  "id": "S{4:]_IwN2`Kr7]a)J_j",
                                                                                                  "inputs": {
                                                                                                    "A": {
                                                                                                      "block": {
                                                                                                        "fields": {
                                                                                                          "THIS": false,
                                                                                                          "VAR": "boardVariable:Tick"
                                                                                                        },
                                                                                                        "id": "pDNV-(dHVX1jm?VKc$[6",
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
                                                                                                            "id": "ec;fD/S5v@$zI1xMqqt`"
                                                                                                          }
                                                                                                        },
                                                                                                        "id": "m?,[^V5:}/V8Bc#0IW,y",
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
                                                                                                  "id": "iroh{F-G-,%!?6L.dRlL",
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
                                                                                              "NUM": 2700
                                                                                            },
                                                                                            "id": "ABRZdsc(b,NmldEQN~nH",
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
        "x": 715,
        "y": -1845
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
                            "next": {
                              "block": {
                                "fields": {
                                  "TYPE": "board",
                                  "VAR": {
                                    "id": "{3f{M(~=@{l{G2v$+EpC"
                                  }
                                },
                                "id": "K=MqOj-rA6J?7i!k1,cv",
                                "inputs": {
                                  "VALUE": {
                                    "block": {
                                      "fields": {
                                        "NUM": 999
                                      },
                                      "id": "m]U]Oa2|]+CXHZP445s$",
                                      "type": "math_number"
                                    }
                                  }
                                },
                                "next": {
                                  "block": {
                                    "fields": {
                                      "TYPE": "board",
                                      "VAR": {
                                        "id": "V3!I#9ZxGNJUFfqc$Uyk"
                                      }
                                    },
                                    "id": "N){mgKM$5V2}):B[A1my",
                                    "inputs": {
                                      "VALUE": {
                                        "block": {
                                          "fields": {
                                            "NUM": 100
                                          },
                                          "id": "*f$1r=NLxn7*%n,zI#x,",
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
                                    "id": "P^p4QD$I*Br|L316}YTn"
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
                        "id": "fDexjWy[wSL[f[20TBS*"
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
        "x": 725,
        "y": 4405
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Old_Map_Default3_Wave3",
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
      "id": ")ou4waRr]e99J*/yf?vq",
      "name": "@Map/Variable01"
    },
    {
      "id": "r-wY3tzf%@mK2:Sj$j0Z",
      "name": "@Map/Variable02"
    },
    {
      "id": "j:E2!J?[wvA?9i,(vHl8",
      "name": "@Map/Variable03"
    },
    {
      "id": "Oib3]uBfN]uodjUTAa:)",
      "name": "@Map/Variable04"
    },
    {
      "id": "!_:4/1?c[_ZR^cZqH`vG",
      "name": "@Map/Variable05"
    },
    {
      "id": "`)XAkB/3zV9O^HY!~t1}",
      "name": "@Map/Encounter/Unit1ID"
    },
    {
      "id": "4r`#l7/Y(.CFzKfxcv$!",
      "name": "@Map/Encounter/Unit2ID"
    },
    {
      "id": "tc^-]ZU,O6Xxv6q)!4w)",
      "name": "@Map/Encounter/Unit3ID"
    },
    {
      "id": "u4h(dlXz#)PkkyW7A)Y:",
      "name": "@Map/Encounter/Unit4ID"
    },
    {
      "id": "o-kJU9#QzkDMU5Q!)}!8",
      "name": "@Map/Encounter/Unit5ID"
    },
    {
      "id": "7aY*Pg;%KURpz|9(m*bp",
      "name": "@Map/Encounter/Unit1Percent"
    },
    {
      "id": "}NB%o]3X-q;~[~D?s=cO",
      "name": "@Map/Encounter/Unit2Percent"
    },
    {
      "id": "vFOvXLu]VoN%VXaBt{/U",
      "name": "@Map/Encounter/Unit3Percent"
    },
    {
      "id": "4]j}5M5109~QZLw[m5D6",
      "name": "@Map/Encounter/Unit4Percent"
    },
    {
      "id": ":62rKsIGmkK9e7~F74Db",
      "name": "@Map/Encounter/Unit5Percent"
    },
    {
      "id": "R/WKN[eXrWDiLzQ`Qe6P",
      "name": "Map/WaveStartTick"
    },
    {
      "id": "wWoE~-N041culE$`h%/?",
      "name": "@Unit/Variable01"
    },
    {
      "id": "P8MB!:(L00U{j.lqp~-o",
      "name": "@Unit/Variable02"
    },
    {
      "id": "1k;GB=KK)}:im_$s_hjo",
      "name": "@Unit/Variable03"
    },
    {
      "id": "k[AEKa.I)B~Sw|AEA+5e",
      "name": "@Unit/Variable04"
    },
    {
      "id": "!I@V@4PZ-46h[J`9{U_]",
      "name": "@Unit/Variable05"
    },
    {
      "id": "k((V~cG_h`[Bl;l0hsb,",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "1!!+nRso(^HvsIXMUqn4",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "nI4c5}lm{J-$N}`@H-.g",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "t-T#ns`H+i0!_!3ieSd=",
      "name": "@Skill/Trait/BlastIncreaseKBPercent"
    },
    {
      "id": "z{l*CPA=Nl+gAg=C_(#^",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "0]xC0EcKaOtp#rKN$)+S",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "2ICd*/,-x.k)?4@xB]mO",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "Z@5=2JcD`B]wGc#x5BlD",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "u?J}([XLacmT{Qtd@glj",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "dU]lGVH[:KpJNG{)kw~1",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "6:OWZ=V.7mDFzR^8N{Ns",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "1vlEhEW~(@BmvcH(k~kh",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "nF2Ggh0Zk*#]3(;0FLnz",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "pXrK,x*[*f5LiCDTl#y=",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "47!$+pZO0Q{Q3}w^L]RL",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "-tOcLLCZcM_9Xy~k-Z?L",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "WNc!,OK4X24.r`)4hC{S",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "d0},m(|P4$,_=6z.R#L^",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "tE*^stL~~o{0Nmsj`~V8",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "hLSWe_l/=x[+G7wI}aB;",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "2Q3x(v$i^6}%sNE|QRoX",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": ".j0:jrqqo`c,JdQ(6`!Q",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": ")5aY+d3id93Gqh;ZpQ7B",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "vr-yQrpZh%=c6V5N].#~",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "tC6f!?,i/VT(b#C=UR22",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "z(*bb^lga)wTW$hcvzO1",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "8%*=t3%ey;/dhZjEJCTh",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "7~6|.1yD(Lm9)DNBVA^a",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "7xZe}(Wa1TYwf!OP=$5L",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "|G$vuKLRm!2axX$G84W%",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "P^p4QD$I*Br|L316}YTn",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "*Xeqm-PNQF*H%UQb(;0r",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "kb0,{D*UJk;qNK$euoL0",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "`Q1Aviup}QzxDmnuJ})2",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "m+t)M-Y#bW[]!,-|LHIv",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "d~wQC|16Av{?qYE|mMyx",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "}3b@9:h(9N55Ki8wWU{Y",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "rnZp:2A5L.{aATm/`T6w",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "kmB$HhJhsjy+7$`x|CNg",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "yc=:WXh*E?F4dwOv;C25",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "~SLf4_Tarw~1NWSrv*-G",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "{|kVIIwwGP~+ME/KYNHb",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "RhS}la*Ih8_=p,@#59FR",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "@_OMm.|0.?h[XVF}8Yv1",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "S;XX9MW]4Dm-#j_#~-Q,",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "%f:m~oFuDh]-?%u/Hu@D",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "Rq[!6B^h(lguQE9D2yz|",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "b}]Det#dA%-bbxZBpzI*",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "T~}lo]aot7;oVfYE3)zF",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "C_;k)l*SsGD#yS^5SN4.",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": ":t}d/TM=B^V3OmR`Sc$-",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "$]Dcj-qBOtPb8%R7:Je?",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "un}OpSu;EqjITZyG:lwB",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "rupx?L|C~iUJ7`c0W?7m",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "SzqW~zh2Ur~Gzr4o?=cM",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "|HCOFxmvAIAfOjb6],^p",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "L^]]8;:)vDAbuabGBJ=T",
      "name": "보석 상점"
    },
    {
      "id": "Qz:v63kV8*L59jGRDHx(",
      "name": "Map/Wave"
    },
    {
      "id": "_17*RV851BcF4wn7O1?f",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "rh;$L)r%,J*;M9NfCu:J",
      "name": "Map/Wave/Step"
    },
    {
      "id": "l/;rq}B+tO:|;pdyM+fm",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "ec;fD/S5v@$zI1xMqqt`",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "[pdIt#[(nJ$O}K@.Vx)_",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": ":exT)%gVFw,=tcjABwlL",
      "name": "Map/Wave/State"
    },
    {
      "id": "ZDeA@4fR+s4}1d[;?!Ec",
      "name": "Gem shops"
    },
    {
      "id": "qZPUi(Ys3$i=TbNtn3/0",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "fDexjWy[wSL[f[20TBS*",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "+lASf.QHH`FuX4bm_8,R",
      "name": "Zem"
    },
    {
      "id": "0OK;pwpY/]5O/``nk{|C",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "]i$C$2^zjgxsHg~tgpW%",
      "name": "Gem"
    },
    {
      "id": "R@%rHbSp1Q~u:hI`+61)",
      "name": "Map/IsStart"
    },
    {
      "id": "3m(hiW5hGweG(*THBN6d",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "#YNmUhSgl|cRA#brp`iw",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "Yd{O{{+/6-%,o~*]Hm[N",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "$x!l]l4R/TEUi8yj_4Nd",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "QE~C/qCxLbrONiwAUL]a",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "$^ff*Yo2U3;3J6gL4Feo",
      "name": "@Map/Player/InitUseSkill3"
    }
  ]
}