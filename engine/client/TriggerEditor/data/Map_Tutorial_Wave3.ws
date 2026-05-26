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
                          "TEXT": "Default3_Battle_03_01"
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
                      "id": "^#^=5U4i@WJs=A8~L;hC",
                      "inputs": {
                        "ARG0": {
                          "block": {
                            "fields": {
                              "NUM": 2
                            },
                            "id": "*gvW^8y%]7OjIG%,.NZ_",
                            "type": "math_number"
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
                                            "NUM": 2400
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
                                  "next": {
                                    "block": {
                                      "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                                      "fields": {
                                        "NAME": "boardMethod:BlockSkillAction",
                                        "THIS": true
                                      },
                                      "id": "OWHDp9#2V%*3KBiFi$!z",
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
                                  "type": "function_call"
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
                    "OP": "AND"
                  },
                  "id": "+^#cG1`]fLnh2E@-5T%z",
                  "inputs": {
                    "A": {
                      "block": {
                        "fields": {
                          "OP": "EQ"
                        },
                        "id": "``q66dHP3r@G=Pnz$H!L",
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
                              "id": "ngW%Rx%Z@zS26=NGd0MG",
                              "type": "variables_get"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "BOOL": "FALSE"
                              },
                              "id": "RyTa(zuwEHG$kZt~wBZ`",
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
                        "id": "tS|NFvDL+jQ)gdhB7#I0",
                        "inputs": {
                          "A": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": ":exT)%gVFw,=tcjABwlL"
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
        "x": 805,
        "y": 365
      },
      {
        "id": "R8x;pE4rO|Wkq[vt*aWb",
        "inputs": {
          "DO0": {
            "block": {
              "id": "J(chj-bu#UV3V$.[}_D!",
              "inputs": {
                "DO0": {
                  "block": {
                    "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                    "fields": {
                      "NAME": "boardMethod:ShowPopup",
                      "THIS": false
                    },
                    "id": "!!fPA68A5:Mvu8RobN5]",
                    "inputs": {
                      "TEXT": {
                        "block": {
                          "fields": {
                            "TEXT": "Popup_BigWaveAlert"
                          },
                          "id": "#!=rXziH5jzd/x:IOOGk",
                          "type": "text"
                        }
                      },
                      "VAR1": {
                        "block": {
                          "fields": {
                            "NUM": 0
                          },
                          "id": "}Fiuq}=MP{OSyu!ZY8:u",
                          "type": "math_number"
                        }
                      }
                    },
                    "type": "function_call_with_arguments"
                  }
                },
                "IF0": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "ge!d=E@PlTC]uR^j`xXv",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "E{57pgP9;@vD|$W]R{p1",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "THIS": false,
                                  "VAR": "boardVariable:Tick"
                                },
                                "id": "I):$O`,qd])VacN_52Cw",
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
                                "id": "t{RRQDES:W];;iTw)/$9",
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
                            "NUM": 1035
                          },
                          "id": "pVO;[U^D$m1!}L}ytlUq",
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
                  "id": "j%022+?a!-flR^RQGu{c",
                  "inputs": {
                    "DO0": {
                      "block": {
                        "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                        "fields": {
                          "NAME": "boardMethod:ShowPopup",
                          "THIS": false
                        },
                        "id": "GeZex#vtFWn]b$(Ou|h_",
                        "inputs": {
                          "TEXT": {
                            "block": {
                              "fields": {
                                "TEXT": "Popup_BigWaveAlert"
                              },
                              "id": "+Se7^^{eELnPe0kd@4~M",
                              "type": "text"
                            }
                          },
                          "VAR1": {
                            "block": {
                              "fields": {
                                "NUM": 0
                              },
                              "id": "y$yo^u|CK3A=9zhVBdIK",
                              "type": "math_number"
                            }
                          }
                        },
                        "type": "function_call_with_arguments"
                      }
                    },
                    "IF0": {
                      "block": {
                        "fields": {
                          "OP": "EQ"
                        },
                        "id": "]X[-e-#h.E3j7zZNTFj3",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "OP": "MINUS"
                              },
                              "id": "g9%|cx^7Z7t`g7r;Rn{^",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "THIS": false,
                                      "VAR": "boardVariable:Tick"
                                    },
                                    "id": ",+!S7dNqaF_)cREA8XRv",
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
                                    "id": "^@M7q3E=]%P}MfoBvn^k",
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
                                "NUM": 1935
                              },
                              "id": "bUdDVIdh=x[SSs+=doTH",
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
                                                  "id": "8%*=t3%ey;/dhZjEJCTh"
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
                                              "id": "t(A-lNqEGV?I[9Y.rvK/",
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
                                                    "id": "SR,4SbvVeEV:8sI5sC-_",
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
                                                    "id": "`0LN^AJyuV=w)k.0zRSO",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "extraState": "<mutation></mutation>",
                                                          "fields": {
                                                            "TYPE": "board",
                                                            "VAR": {
                                                              "id": ")ou4waRr]e99J*/yf?vq"
                                                            }
                                                          },
                                                          "id": "|{,cf{^4UyXUooftrP69",
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
                                                          "id": "v}OYoWz`NE1L-cVHLGan",
                                                          "inputs": {
                                                            "A": {
                                                              "block": {
                                                                "fields": {
                                                                  "OP": "ADD"
                                                                },
                                                                "id": "2K0NwlRIa.!4BSPVB;8j",
                                                                "inputs": {
                                                                  "A": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "THIS": false,
                                                                        "VAR": "unitVariable:VelocityX"
                                                                      },
                                                                      "id": "2i$m3|gn(TJ^F4l#@0h1",
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
                                                                      "id": "EGZ/g(e(m[Jmzz30H@w6",
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
                                                                "id": "!gNOX$Ms,o5;zyjY/iqt",
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
                                                      "id": "7~6|.1yD(Lm9)DNBVA^a"
                                                    }
                                                  },
                                                  "id": "fPwlcdB),5s!3gO}Ai3K",
                                                  "type": "variables_get"
                                                }
                                              },
                                              "ARG2": {
                                                "block": {
                                                  "fields": {
                                                    "OP": "ADD"
                                                  },
                                                  "id": "em-bh:0M=lf/D@_c4c}c",
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
                                                        "id": "dNYeX]-T.F_L6XDe0:*7",
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
                                                        "id": "f,`1Q,2X7OJ[]JE+-M(,",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "extraState": "<mutation></mutation>",
                                                              "fields": {
                                                                "TYPE": "board",
                                                                "VAR": {
                                                                  "id": ")ou4waRr]e99J*/yf?vq"
                                                                }
                                                              },
                                                              "id": ",WV|C7Y19]ZuOz0Vd1m6",
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
                                                              "id": "7N;57G(|t-B9[,mD|#*`",
                                                              "inputs": {
                                                                "A": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "OP": "ADD"
                                                                    },
                                                                    "id": "Nq/73H?acJ{.%[unM#I=",
                                                                    "inputs": {
                                                                      "A": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "THIS": false,
                                                                            "VAR": "unitVariable:VelocityX"
                                                                          },
                                                                          "id": "*e4Q^[V.@(_IDpFp);Ir",
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
                                                                          "id": "8k@m3b{sP,M*I+2ZpR^;",
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
                                                                    "id": "?=W:#uPg,(k.u;82-N65",
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
                                                                  "id": "ec;fD/S5v@$zI1xMqqt`"
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
                                                          "NUM": 210
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
                                                    "NUM": 195
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
                                                      "id": "ec;fD/S5v@$zI1xMqqt`"
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
                                              "NUM": 2400
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
                                                "id": "ec;fD/S5v@$zI1xMqqt`"
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
                                        "NUM": 195
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
                              "id": "?uWQ=_1^jjB2GtCRfyvv",
                              "inputs": {
                                "DO0": {
                                  "block": {
                                    "id": "DU/=u])9aRm|5qzF_s_~",
                                    "inputs": {
                                      "DO0": {
                                        "block": {
                                          "id": "lp/6b`x?*7.u63%ihcPz",
                                          "inputs": {
                                            "DO0": {
                                              "block": {
                                                "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                "fields": {
                                                  "NAME": "boardMethod:AddUnit",
                                                  "THIS": true
                                                },
                                                "id": "u*C/aZ*GH@,],g3m4bvS",
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
                                                      "id": "IQ]Sfyh;l7s!UWSy.!C*",
                                                      "type": "variables_get"
                                                    }
                                                  },
                                                  "ARG2": {
                                                    "block": {
                                                      "fields": {
                                                        "OP": "ADD"
                                                      },
                                                      "id": "LSXI-)Xuu;N%Pr4[MeU(",
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
                                                            "id": "l*md~ygdY3V$g(FD|D#a",
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
                                                            "id": "0t`IY%.Bpf)Kb~RO68Gq",
                                                            "inputs": {
                                                              "A": {
                                                                "block": {
                                                                  "extraState": "<mutation></mutation>",
                                                                  "fields": {
                                                                    "TYPE": "board",
                                                                    "VAR": {
                                                                      "id": ")ou4waRr]e99J*/yf?vq"
                                                                    }
                                                                  },
                                                                  "id": "#nm`~zc1L:lR[g;QfW$!",
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
                                                                  "id": "Sk)l;3ZxT3rIHAO6RaP}",
                                                                  "inputs": {
                                                                    "A": {
                                                                      "block": {
                                                                        "fields": {
                                                                          "OP": "ADD"
                                                                        },
                                                                        "id": "]rIRFsehWLvr|(HUaI)C",
                                                                        "inputs": {
                                                                          "A": {
                                                                            "block": {
                                                                              "fields": {
                                                                                "THIS": false,
                                                                                "VAR": "unitVariable:VelocityX"
                                                                              },
                                                                              "id": "u$NGRmyX7:i[h+_[-ZpL",
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
                                                                              "id": "{Mz6j5Rk5Iq]QRK@s];0",
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
                                                                        "id": "@19bn1mKe/?QkRtgK8EW",
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
                                                      "id": "Su~/MF`fnE[XH+OtajGz",
                                                      "type": "math_number"
                                                    }
                                                  },
                                                  "ARG5": {
                                                    "block": {
                                                      "fields": {
                                                        "VAR": "Enemy"
                                                      },
                                                      "id": "XJdK}UApq6Gz#o9eh|^V",
                                                      "type": "teamtag_get"
                                                    }
                                                  },
                                                  "ARG6": {
                                                    "block": {
                                                      "fields": {
                                                        "NUM": 1
                                                      },
                                                      "id": ",,fpsy%$8tw0#qg1*e2(",
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
                                                "id": "w{6{p|zj89chF~}z|t}y",
                                                "inputs": {
                                                  "A": {
                                                    "block": {
                                                      "id": "PVUGcwA~ULi/rEf6D[3|",
                                                      "inputs": {
                                                        "DIVIDEND": {
                                                          "block": {
                                                            "fields": {
                                                              "OP": "MINUS"
                                                            },
                                                            "id": "T*%s$@s,4|$(3=~W=6g-",
                                                            "inputs": {
                                                              "A": {
                                                                "block": {
                                                                  "fields": {
                                                                    "THIS": false,
                                                                    "VAR": "boardVariable:Tick"
                                                                  },
                                                                  "id": "g/~-70Pj^F#-;`(P1Z}1",
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
                                                                  "id": "]!.}#%OJ^L?g2^B,3,*q",
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
                                                            "id": "/0cfsqQorBG2d*.]x-EU",
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
                                                        "NUM": 525
                                                      },
                                                      "id": "kQ=A`/C^C6ZS,Gh5uz+`",
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
                                          "id": "kH{`)qT[hPQn!|/@x~N%",
                                          "inputs": {
                                            "A": {
                                              "block": {
                                                "fields": {
                                                  "OP": "MINUS"
                                                },
                                                "id": "T6,LK`kPN};9_2JjYOW=",
                                                "inputs": {
                                                  "A": {
                                                    "block": {
                                                      "fields": {
                                                        "THIS": false,
                                                        "VAR": "boardVariable:Tick"
                                                      },
                                                      "id": "#)=%QzWVZ,r19|8EJT~8",
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
                                                      "id": "OL+Gi/}JI5lKOz0HF+.f",
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
                                                "id": "pl=mpNf^PvN8de?FqfGl",
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
                                    "id": "$jA?:S4q)U{a}mlkdrE7",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "fields": {
                                            "OP": "MINUS"
                                          },
                                          "id": "j=*3E[QOkX_0+r,(l/F7",
                                          "inputs": {
                                            "A": {
                                              "block": {
                                                "fields": {
                                                  "THIS": false,
                                                  "VAR": "boardVariable:Tick"
                                                },
                                                "id": "tdB]MNy}`%%zWN1t6eJ3",
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
                                                "id": "!*tg!zZv#=3T1+h~QYYY",
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
                                            "NUM": 1050
                                          },
                                          "id": "^E5,-VTp`bY]wEV$LHkc",
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
                                  "id": "cVtE7wh{=$KK/.|K7*Pu",
                                  "inputs": {
                                    "DO0": {
                                      "block": {
                                        "id": "`kMj)swlX(2C.},EPUg3",
                                        "inputs": {
                                          "DO0": {
                                            "block": {
                                              "id": "`!ZjS|!0/`bu(zk):BnH",
                                              "inputs": {
                                                "DO0": {
                                                  "block": {
                                                    "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                    "fields": {
                                                      "NAME": "boardMethod:AddUnit",
                                                      "THIS": true
                                                    },
                                                    "id": "Fv@!8Rot6GqYappB3YRs",
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
                                                          "id": "]ZUv-D5U3:Ad/mtdSquS",
                                                          "type": "variables_get"
                                                        }
                                                      },
                                                      "ARG2": {
                                                        "block": {
                                                          "fields": {
                                                            "OP": "ADD"
                                                          },
                                                          "id": "l+Cl$,o;%d#J`ySAr*+l",
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
                                                                "id": "1:g$sXe8LDzoiR.fv]?Z",
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
                                                                "id": "pv}I9Hq`31Xh{OSkYLYj",
                                                                "inputs": {
                                                                  "A": {
                                                                    "block": {
                                                                      "extraState": "<mutation></mutation>",
                                                                      "fields": {
                                                                        "TYPE": "board",
                                                                        "VAR": {
                                                                          "id": ")ou4waRr]e99J*/yf?vq"
                                                                        }
                                                                      },
                                                                      "id": "$FEh?].]*qJ8#=P[Un4/",
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
                                                                      "id": "6IuV`y(idg{#N_3eW47F",
                                                                      "inputs": {
                                                                        "A": {
                                                                          "block": {
                                                                            "fields": {
                                                                              "OP": "ADD"
                                                                            },
                                                                            "id": "xQ$Q1{M~0=vWU.:O[4UF",
                                                                            "inputs": {
                                                                              "A": {
                                                                                "block": {
                                                                                  "fields": {
                                                                                    "THIS": false,
                                                                                    "VAR": "unitVariable:VelocityX"
                                                                                  },
                                                                                  "id": "@eBZ/).]:ra*#E-bKxGO",
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
                                                                                  "id": "fWq(!|!U.~^%B_%N[@bP",
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
                                                                            "id": "4D3$-to:[f{crm-RWKd?",
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
                                                          "id": "s(@4V-pdHgyDktC.2Z7^",
                                                          "type": "math_number"
                                                        }
                                                      },
                                                      "ARG5": {
                                                        "block": {
                                                          "fields": {
                                                            "VAR": "Enemy"
                                                          },
                                                          "id": "|EO.9byjW]4`30;q4QOo",
                                                          "type": "teamtag_get"
                                                        }
                                                      },
                                                      "ARG6": {
                                                        "block": {
                                                          "fields": {
                                                            "NUM": 1
                                                          },
                                                          "id": "[$dY?i0sd89TDe#V3AV6",
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
                                                    "id": "AjY@|Rg;L!~yq6F05zq2",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "id": "[(mV?JxaBdVR8eciEm}p",
                                                          "inputs": {
                                                            "DIVIDEND": {
                                                              "block": {
                                                                "fields": {
                                                                  "OP": "MINUS"
                                                                },
                                                                "id": "+pp9~q~#J1Sz*8Y0LM,2",
                                                                "inputs": {
                                                                  "A": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "THIS": false,
                                                                        "VAR": "boardVariable:Tick"
                                                                      },
                                                                      "id": "ES`Gx|EB7{(]ZL7;RR-e",
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
                                                                      "id": "{CUQf/8@wM(tlL+c|G{s",
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
                                                                "id": "MVaR+=A+Xl:kEy9o0MAg",
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
                                                            "NUM": 15
                                                          },
                                                          "id": "|vI0rqibdZ@$T}-BIUqy",
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
                                              "id": "[DPSKFqIq0QpvP)Oh.:t",
                                              "inputs": {
                                                "A": {
                                                  "block": {
                                                    "fields": {
                                                      "OP": "MINUS"
                                                    },
                                                    "id": "M2vHI/S|v$_T*Pv[4MYZ",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "fields": {
                                                            "THIS": false,
                                                            "VAR": "boardVariable:Tick"
                                                          },
                                                          "id": "+1%D5@bLodcx;vFW-w/r",
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
                                                          "id": ":S}y-W(Gp%mCf9mt%Wk!",
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
                                                    "id": "{jMOR`4lGLweT%UD44d?",
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
                                        "id": "E74FlmB2q2~3[4mp4zbu",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "OP": "MINUS"
                                              },
                                              "id": "kp{yrFMS[yOpr~(:*zf~",
                                              "inputs": {
                                                "A": {
                                                  "block": {
                                                    "fields": {
                                                      "THIS": false,
                                                      "VAR": "boardVariable:Tick"
                                                    },
                                                    "id": "IGa?RcZ}5j8.=[:Xt|UP",
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
                                                    "id": "O{Ti4r`pcXfQ4p?`|EvS",
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
                                                "NUM": 1065
                                              },
                                              "id": "EeLSY+VV?iBr`-s,*~J,",
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
                                      "id": "hA{4=VKt|)ZU_:K,Ba$R",
                                      "inputs": {
                                        "DO0": {
                                          "block": {
                                            "id": ":rfzQbN3PF]QYS/0^p6A",
                                            "inputs": {
                                              "DO0": {
                                                "block": {
                                                  "id": "az$Ma9;`CuYEstO:=FCs",
                                                  "inputs": {
                                                    "DO0": {
                                                      "block": {
                                                        "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                        "fields": {
                                                          "NAME": "boardMethod:AddUnit",
                                                          "THIS": true
                                                        },
                                                        "id": "NL)0O2L6@.7dT,a2|E[R",
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
                                                              "id": ")};|VhpsPB*q`Q3Xih-.",
                                                              "type": "variables_get"
                                                            }
                                                          },
                                                          "ARG2": {
                                                            "block": {
                                                              "fields": {
                                                                "OP": "ADD"
                                                              },
                                                              "id": "t?ADh#yN!*E8+qVBzsJt",
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
                                                                    "id": "rV64/P|RvWBE;GqV+i`B",
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
                                                                    "id": "g[7UyDP?V`]t|wwVN/Qc",
                                                                    "inputs": {
                                                                      "A": {
                                                                        "block": {
                                                                          "extraState": "<mutation></mutation>",
                                                                          "fields": {
                                                                            "TYPE": "board",
                                                                            "VAR": {
                                                                              "id": ")ou4waRr]e99J*/yf?vq"
                                                                            }
                                                                          },
                                                                          "id": "{{af_FF:h:u[lU8zI(xv",
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
                                                                          "id": "CP]HN*i5v@wmFpsHyXUM",
                                                                          "inputs": {
                                                                            "A": {
                                                                              "block": {
                                                                                "fields": {
                                                                                  "OP": "ADD"
                                                                                },
                                                                                "id": "z$7,,p,_,a^U7f2JFb[~",
                                                                                "inputs": {
                                                                                  "A": {
                                                                                    "block": {
                                                                                      "fields": {
                                                                                        "THIS": false,
                                                                                        "VAR": "unitVariable:VelocityX"
                                                                                      },
                                                                                      "id": "(;]5zsU~eaa$C=9Uotz+",
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
                                                                                      "id": "Y)(Z4ODfosf)azE4^`56",
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
                                                                                "id": "Vua=FSt:eShAho~fTGt?",
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
                                                              "id": "#*LP+ot@:r#$SMM.Oq1w",
                                                              "type": "math_number"
                                                            }
                                                          },
                                                          "ARG5": {
                                                            "block": {
                                                              "fields": {
                                                                "VAR": "Enemy"
                                                              },
                                                              "id": "@`2:-)!wH@@uzSj3i!v@",
                                                              "type": "teamtag_get"
                                                            }
                                                          },
                                                          "ARG6": {
                                                            "block": {
                                                              "fields": {
                                                                "NUM": 1
                                                              },
                                                              "id": "uL4Tv)j5LIz3dNhoO##5",
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
                                                        "id": "yD~r+pvIN{:sB4~:q|2c",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "id": "UtvRCPaK9=r)$]qU/jVG",
                                                              "inputs": {
                                                                "DIVIDEND": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "OP": "MINUS"
                                                                    },
                                                                    "id": "b*XsiI6s^UG1$/=XOLeh",
                                                                    "inputs": {
                                                                      "A": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "THIS": false,
                                                                            "VAR": "boardVariable:Tick"
                                                                          },
                                                                          "id": "fhX*n%3uheW?TGmEM2b$",
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
                                                                          "id": "]m.|(US+pR`mzKCVK[G/",
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
                                                                      "NUM": 420
                                                                    },
                                                                    "id": "mxKrNExhtYC2[FhQ^TPz",
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
                                                                "NUM": 240
                                                              },
                                                              "id": "IeSV%$R;S4|J2g$o@Y/~",
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
                                                  "id": "R9h:`I9:K_Ot@/06O0af",
                                                  "inputs": {
                                                    "A": {
                                                      "block": {
                                                        "fields": {
                                                          "OP": "MINUS"
                                                        },
                                                        "id": "w1JbFs8q$p2h3QUlq[QE",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "fields": {
                                                                "THIS": false,
                                                                "VAR": "boardVariable:Tick"
                                                              },
                                                              "id": "a^:ObWfY.zo$C7Gkl9QP",
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
                                                              "id": "_QS#]|kE%:%A30LKwgp5",
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
                                                        "id": "Y`G!3]XqhGkWLoV_]^(}",
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
                                            "id": "]6-fSHsc~ynTcwR,dSD2",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "fields": {
                                                    "OP": "MINUS"
                                                  },
                                                  "id": "oD7,DK)@[U=`Jjas%SR8",
                                                  "inputs": {
                                                    "A": {
                                                      "block": {
                                                        "fields": {
                                                          "THIS": false,
                                                          "VAR": "boardVariable:Tick"
                                                        },
                                                        "id": "p?E8o=5L1Ga5M,OXg^De",
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
                                                        "id": "WHK*wN@z-h$-,QXC4rbN",
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
                                                  "id": "v(k5]6oh1ifW|+XyYi^.",
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
                                          "id": "Fd~;UH1^fU118#TDuQI5",
                                          "inputs": {
                                            "DO0": {
                                              "block": {
                                                "id": "@SZfT2vb^V(yNR]o/OAs",
                                                "inputs": {
                                                  "DO0": {
                                                    "block": {
                                                      "id": "t6y-Xf)hosl(6Y[QsmPw",
                                                      "inputs": {
                                                        "DO0": {
                                                          "block": {
                                                            "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                            "fields": {
                                                              "NAME": "boardMethod:AddUnit",
                                                              "THIS": true
                                                            },
                                                            "id": ".E;$=JA.H/fT6pe7Sd]O",
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
                                                                  "id": "cY-W#;@:gt*+H,Z08}QJ",
                                                                  "type": "variables_get"
                                                                }
                                                              },
                                                              "ARG2": {
                                                                "block": {
                                                                  "fields": {
                                                                    "OP": "ADD"
                                                                  },
                                                                  "id": "+Y(2c`k`o-:LHGwhc^2|",
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
                                                                        "id": "=:VxOl2TsT/y%gj.]LS0",
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
                                                                        "id": "z=?9oZ|!4t8a/+:a*Zd?",
                                                                        "inputs": {
                                                                          "A": {
                                                                            "block": {
                                                                              "extraState": "<mutation></mutation>",
                                                                              "fields": {
                                                                                "TYPE": "board",
                                                                                "VAR": {
                                                                                  "id": ")ou4waRr]e99J*/yf?vq"
                                                                                }
                                                                              },
                                                                              "id": "|N#sh@s7}/lgCd@JZr;e",
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
                                                                              "id": "lT7OEb#Jp.[oOkUF25us",
                                                                              "inputs": {
                                                                                "A": {
                                                                                  "block": {
                                                                                    "fields": {
                                                                                      "OP": "ADD"
                                                                                    },
                                                                                    "id": "GY%qN=%U;n,BVXZNvAAx",
                                                                                    "inputs": {
                                                                                      "A": {
                                                                                        "block": {
                                                                                          "fields": {
                                                                                            "THIS": false,
                                                                                            "VAR": "unitVariable:VelocityX"
                                                                                          },
                                                                                          "id": "(p`xB[+jzQ_Z=b~b%7W$",
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
                                                                                          "id": "6hG4cx0-y!|;DjUO4n#v",
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
                                                                                    "id": "3e_70:h8^-%3mZ=jQj0h",
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
                                                                  "id": "UP8O-@2#7=LXUug#9us~",
                                                                  "type": "math_number"
                                                                }
                                                              },
                                                              "ARG5": {
                                                                "block": {
                                                                  "fields": {
                                                                    "VAR": "Enemy"
                                                                  },
                                                                  "id": "T!u;W4qTB$cSm,aIz_,2",
                                                                  "type": "teamtag_get"
                                                                }
                                                              },
                                                              "ARG6": {
                                                                "block": {
                                                                  "fields": {
                                                                    "NUM": 1
                                                                  },
                                                                  "id": "[i;d.N-.%PJ9F:#TUR)I",
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
                                                            "id": "PynK(R3i6!jAbtY,8!M(",
                                                            "inputs": {
                                                              "A": {
                                                                "block": {
                                                                  "id": "RQ3T;8MYaYf=GZ?28S?#",
                                                                  "inputs": {
                                                                    "DIVIDEND": {
                                                                      "block": {
                                                                        "fields": {
                                                                          "OP": "MINUS"
                                                                        },
                                                                        "id": "yg.zL9^n^5h.85L7a`-c",
                                                                        "inputs": {
                                                                          "A": {
                                                                            "block": {
                                                                              "fields": {
                                                                                "THIS": false,
                                                                                "VAR": "boardVariable:Tick"
                                                                              },
                                                                              "id": "2D^]yR%Y6zqT!_-3g)4U",
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
                                                                              "id": "D${J_}Qo}3k@Eb$*##G:",
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
                                                                          "NUM": 900
                                                                        },
                                                                        "id": "iVC@uOxfG,OT^WRzLiX/",
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
                                                                    "NUM": 135
                                                                  },
                                                                  "id": "lB,bn:u2bDtTG2*mGsfL",
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
                                                      "id": "nmK}V2#q=c4_0DE_jrQ2",
                                                      "inputs": {
                                                        "A": {
                                                          "block": {
                                                            "fields": {
                                                              "OP": "MINUS"
                                                            },
                                                            "id": "X{)l%]crb;/S~ZB=r~-F",
                                                            "inputs": {
                                                              "A": {
                                                                "block": {
                                                                  "fields": {
                                                                    "THIS": false,
                                                                    "VAR": "boardVariable:Tick"
                                                                  },
                                                                  "id": "FO))d#N-JShPW$lx%Vz=",
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
                                                                  "id": "Ya$d=7?FyKyU];z,ZvA2",
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
                                                            "id": "`n|kS}bALL.`zN@=-Am$",
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
                                                "id": "%`[3t62)3AYp7ql,x*z@",
                                                "inputs": {
                                                  "A": {
                                                    "block": {
                                                      "fields": {
                                                        "OP": "MINUS"
                                                      },
                                                      "id": "Vzwo=^^L-7GqsxtsyvAW",
                                                      "inputs": {
                                                        "A": {
                                                          "block": {
                                                            "fields": {
                                                              "THIS": false,
                                                              "VAR": "boardVariable:Tick"
                                                            },
                                                            "id": "O1A*qrO`m-*%:_rBTSaI",
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
                                                            "id": "ir=)WA@8uU?pgF{hk1-$",
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
                                                        "NUM": 1035
                                                      },
                                                      "id": "dd-1yl)w7p5;a+/lQ.}R",
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
          "IF0": {
            "block": {
              "fields": {
                "OP": "AND"
              },
              "id": "qO4[j]}`1NcF*-PGV)Ex",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "GTE"
                    },
                    "id": "Fs6$Y6{lP.ND}A.hD#B=",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": ":exT)%gVFw,=tcjABwlL"
                            }
                          },
                          "id": "Mm?U[Eizn5u{|jjs=.{r",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "^:?{TjKI?L@:`X{Rph0y",
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
                    "id": "Q{ASdoZA/Kqw#8nBx!ff",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": ":exT)%gVFw,=tcjABwlL"
                            }
                          },
                          "id": "5Qy4)5JcgoA%]A5.IHj:",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 3
                          },
                          "id": "?J$3$7=M/.@Q2a*XYb={",
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
        "x": 765,
        "y": 1805
      },
      {
        "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
        "fields": {
          "NAME": "boardMethod:GetMainPlayerUnit",
          "THIS": false
        },
        "id": "#hEWObLaHP.%Hbj$JId8",
        "next": {
          "block": {
            "id": "zTZKiYg^spWXuYx9hD4i",
            "inputs": {
              "DO0": {
                "block": {
                  "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Duration (필수)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "boardMethod:StartTimer",
                    "THIS": false
                  },
                  "id": ";vX3V(@OU-t={a;_fqOI",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "fields": {
                          "NUM": 1
                        },
                        "id": "MV$siX*Gfu22P{,/egna",
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
                      "id": "K,$%,i@lFN:YSI^Bi_4C",
                      "inputs": {
                        "VALUE": {
                          "block": {
                            "fields": {
                              "NUM": 2
                            },
                            "id": "S=^ZETLWr#gVZjFdEa{B",
                            "type": "math_number"
                          }
                        }
                      },
                      "next": {
                        "block": {
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "rAL:DMOg)#l;|a=gBF:["
                            }
                          },
                          "id": "CnPyPz93|T,u1`oN^$V}",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "NUM": 0
                                },
                                "id": "bcf[S5,7)e!3En-S~64X",
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
                  "id": "|nsuq)T0Pz7Ig`cRi/#6",
                  "inputs": {
                    "A": {
                      "block": {
                        "fields": {
                          "OP": "AND"
                        },
                        "id": "fEb/q+UwT9!D@}a./phS",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "THIS": false,
                                "VAR": "unitVariable:HasTarget"
                              },
                              "id": "kRHNb539{.}o@{5q?pdn",
                              "type": "variables_get_reserved"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "OP": "LTE"
                              },
                              "id": "/bAIE4#G!$(fAjMW,U$g",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "THIS": false,
                                      "VAR": "unitVariable:TargetDistance"
                                    },
                                    "id": "{kI]tN`de-).10:ab4dj",
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
                        "id": "98S=dPmi52zr.#ib_LD8",
                        "inputs": {
                          "A": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": ":exT)%gVFw,=tcjABwlL"
                                }
                              },
                              "id": "O%P/k0*x!5@c5Me*McSM",
                              "type": "variables_get"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "!1(B%btf,VtZuz*91WJW",
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
                "id": "/^]tiRh(6y3#%j#RABVD",
                "inputs": {
                  "DO0": {
                    "block": {
                      "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                      "fields": {
                        "NAME": "boardMethod:UnBlockSkillAction",
                        "THIS": false
                      },
                      "id": "jOhIpbYu$wD.fVx}IK?;",
                      "next": {
                        "block": {
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": ":exT)%gVFw,=tcjABwlL"
                            }
                          },
                          "id": "2kz:8bJE?ZtqAWF5kunZ",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "NUM": 3
                                },
                                "id": "G|Po2uUO.H+1]oo.(k2D",
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
                      "id": "q!yBF%H0E}g`E(Z_B%X(",
                      "inputs": {
                        "A": {
                          "block": {
                            "fields": {
                              "OP": "LTE"
                            },
                            "id": "#b~CXnviuIB|-V$qO,cT",
                            "inputs": {
                              "A": {
                                "block": {
                                  "fields": {
                                    "THIS": false,
                                    "VAR": "boardVariable:Timer"
                                  },
                                  "id": "kApf=*15].zW4gM!,/qN",
                                  "type": "variables_get_reserved"
                                }
                              },
                              "B": {
                                "block": {
                                  "fields": {
                                    "NUM": 0
                                  },
                                  "id": "KY9P;q_%?@Ql.U=Me/va",
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
                            "id": "G%g/R6Xbq=;5Oz8r!YYj",
                            "inputs": {
                              "A": {
                                "block": {
                                  "extraState": "<mutation></mutation>",
                                  "fields": {
                                    "TYPE": "board",
                                    "VAR": {
                                      "id": ":exT)%gVFw,=tcjABwlL"
                                    }
                                  },
                                  "id": "|{bnLTS!d{$!4JU8f;Z=",
                                  "type": "variables_get"
                                }
                              },
                              "B": {
                                "block": {
                                  "fields": {
                                    "NUM": 2
                                  },
                                  "id": "_3iRILj1JwWTI`[;aZ+p",
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
        "x": 805,
        "y": 1305
      },
      {
        "id": ".yIK(=J6FBWpdZecl|T9",
        "inputs": {
          "DO0": {
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
                            "NUM": 4
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
                                      "id": "*Xeqm-PNQF*H%UQb(;0r"
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
                                  "id": "uP$Bk%x6B39d}ujJK[mq",
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
                                        "id": "Y1HeMTwuta_Hx:XZPpH$",
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
                                        "id": "v7nF$J9?[P_r4h-`acv|",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "extraState": "<mutation></mutation>",
                                              "fields": {
                                                "TYPE": "board",
                                                "VAR": {
                                                  "id": ")ou4waRr]e99J*/yf?vq"
                                                }
                                              },
                                              "id": ")J8Xd`vZOIUQfL^/H.cB",
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
                                              "id": "`~_Fm{JH52yk5eZzWO1t",
                                              "inputs": {
                                                "A": {
                                                  "block": {
                                                    "fields": {
                                                      "OP": "ADD"
                                                    },
                                                    "id": "3P+S%AXucGI{eLs+t=g+",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "fields": {
                                                            "THIS": false,
                                                            "VAR": "unitVariable:VelocityX"
                                                          },
                                                          "id": "b~4Oi|r.qz;^2%E]@Vtl",
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
                                                          "id": "Zd4Gv5#1Uu*O^P`aMrx,",
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
                                                    "id": "QNkUbB3U!~k`@Hl;t?_{",
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
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "[pdIt#[(nJ$O}K@.Vx)_"
                            }
                          },
                          "id": "m?,[^V5:}/V8Bc#0IW,y",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "THIS": false,
                            "VAR": "boardVariable:Tick"
                          },
                          "id": "pDNV-(dHVX1jm?VKc$[6",
                          "type": "variables_get_reserved"
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
              "id": "c6n=(!;i/SjyaDH?#1B;",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "GTE"
                    },
                    "id": "r;)NyUmC=YJrjB/),qAe",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": ":exT)%gVFw,=tcjABwlL"
                            }
                          },
                          "id": "9ps{3VEh^Z1p)-^%-9+q",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "vh]t{ClyO,fqu]I!;MRL",
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
                    "id": "wL[bv_zZZT|lyTstQqwX",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": ":exT)%gVFw,=tcjABwlL"
                            }
                          },
                          "id": "UqpM4?GZ.RB(wVX!cDnM",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 4
                          },
                          "id": "zVil!($iJgUlT^*^Xz(R",
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
            "id": "zF1M[z^6f98g}$Nn9cC%",
            "inputs": {
              "DO0": {
                "block": {
                  "id": "jKBksb7bbymWu8,nv]e|",
                  "inputs": {
                    "DO0": {
                      "block": {
                        "fields": {
                          "NAME": "Log"
                        },
                        "id": "LwqU1oDK:35@0*]}slQ|",
                        "inputs": {
                          "TEXT": {
                            "block": {
                              "fields": {
                                "TEXT": "Battle ends"
                              },
                              "id": ";%7D8|AmHW}L!0Dx/(@F",
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
                            "id": "g}3Aj^9H7m4q9{mlV9?j",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "fields": {
                                    "VAR": "Enemy"
                                  },
                                  "id": "*JOvvxR(:|{/_:*/y7su",
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
                                "id": "2$zs;Hv!]$1%*`3ok9t4",
                                "inputs": {
                                  "ARG0": {
                                    "block": {
                                      "fields": {
                                        "VAR": "Player"
                                      },
                                      "id": "`+a2R:WxVzJxV^%:Y2ya",
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
                        "id": "xAB*2CS:2j#P|[(TdH7.",
                        "inputs": {
                          "A": {
                            "block": {
                              "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;}]\"></mutation>",
                              "fields": {
                                "NAME": "boardMethod:GetUnitCount",
                                "THIS": false
                              },
                              "id": "t6i+YH6OOWKlYh{:M=M2",
                              "inputs": {
                                "ARG0": {
                                  "block": {
                                    "extraState": "<mutation></mutation>",
                                    "fields": {
                                      "TYPE": "board",
                                      "VAR": {
                                        "id": "*Xeqm-PNQF*H%UQb(;0r"
                                      }
                                    },
                                    "id": "SSh7Z!hYN|)!/4|8K/a1",
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
                              "id": "(Di}{2v`T%_;dyK$rk7t",
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
                  "id": "G)EA),nU2PrBNp~g?N$4",
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
                        "id": "yFHDCQHZTbsG!I1M7AU6",
                        "type": "variables_get"
                      }
                    },
                    "B": {
                      "block": {
                        "fields": {
                          "NUM": 1
                        },
                        "id": "A(,8H/xDggC:MGZfzf#c",
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
        "type": "controls_if",
        "x": 745,
        "y": 5125
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
                        "id": ":exT)%gVFw,=tcjABwlL"
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
                              "id": ":exT)%gVFw,=tcjABwlL"
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
        "x": 795,
        "y": 995
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Map_Tutorial_Wave3",
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
    },
    {
      "id": "Sjw-7+Sb*pif.o;LU5Ao",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "rAL:DMOg)#l;|a=gBF:[",
      "name": "Map/Player/Moving"
    },
    {
      "id": "c0j-eklRU{[K0.kapGO(",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "YLENJIaiZd(niO*;CiHi",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "mZ-Y,qYy%2~{/XtMMuVN",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "pdi?`j8E(v*8HB)D|6;;",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "/IfIBOz8$^1tui:lf]F3",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "k_bC]Vg[U8l+(Y+a+,%y",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "/0dq;wIX/l^vPkKK87W$",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": ".O6q1ID*GW+Vt?Ev^WC%",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "wm7|Y=RG,3q9KN;MF+B@",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "zG7a*|%qcs60`*eL,udq",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "7v;WZF81nef%DO=GL]hN",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "Eo`aJiQ+%|d`*W-[_|0d",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "HQXSl#OfwWLH8`pW+3:^",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "HB2P#{u6pV_vyEk~gK:~",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "JEvIJr]Jp,D2tE-wGBnS",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "iUfYaljBw7bKTmqr1AJj",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "xg,!UR?+]h(Zx+XDVsnx",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "Y}6ph[8V$aN_p~-(_+%g",
      "name": "@Map/Progress"
    },
    {
      "id": "8~}oVrq^Rv#@N0nie~cd",
      "name": "Map/DisplayWinningTeam"
    },
    {
      "id": "+{-OGU%-LW+;tG!fC{kM",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "IDg~V1L9,%t{OW6SnbH|",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "]q@]_PThuTIA(+oX*94p",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "~/Hx103#io`nL)]WIo~y",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "@%81]z-+^_==;/Q_jt5^",
      "name": "@Skill/Variable/08"
    },
    {
      "id": ".!:S|s!ZXqY9$wnXQ:Ed",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "YP:e2OQw/XW`_Bd|pod?",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "(#sMvJz+^;Rldm`3(lW]",
      "name": "🚨 Scout rewards maxed out!\nCollect Gold💰 & Gems💎, and power up!\nPlay Hamster Combat now! 👉 [Play Now]"
    },
    {
      "id": "vgCCqU6~sgkGna.0(AyI",
      "name": "@Map/WaveStartPlayerPosition"
    }
  ]
}