{
  "blocks": {
    "blocks": [
      {
        "id": "K:O2;4d3UF+`A[FL+dnb",
        "inputs": {
          "DO0": {
            "block": {
              "id": "*w|/1#UbwGeT4hAMhzqX",
              "type": "return"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "NEQ"
              },
              "id": "`Xl@R2TqKBR}Ll$q[Gfr",
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
                    "id": "l.(C.nd%ZPwW,*[!73Ol",
                    "type": "variables_get"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "NUM": 2
                    },
                    "id": "h2RZHYq(t+Rzi*)0h{.3",
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
            "id": "7Wb0B/(ie}5.8PJJRvUa",
            "inputs": {
              "DO0": {
                "block": {
                  "fields": {
                    "NAME": "Log"
                  },
                  "id": "jk?z1Ji!7Res;:f9Rh$2",
                  "inputs": {
                    "TEXT": {
                      "block": {
                        "fields": {
                          "TEXT": "Default3_Battle_02_01"
                        },
                        "id": "xH8-veRafjy#xu7$|(r/",
                        "type": "text"
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
                              "id": "!eP)g[a]cC~||~f5TQiZ"
                            }
                          },
                          "id": "tu@/c1k_hJ1!S5Q!6iaD",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "NUM": 1
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
                                  "id": "haV+evEyYXpN85{NOBM_"
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
                                  "next": {
                                    "block": {
                                      "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                                      "fields": {
                                        "NAME": "boardMethod:BlockSkillAction",
                                        "THIS": false
                                      },
                                      "id": "$(X}2D:2Y4=i+G|50TWz",
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
                        "id": "DfTuG5/J0R}EXyV-Yu2t",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "NUM": 18
                              },
                              "id": "T^LpfVR@~M^*38h%[%Mu",
                              "type": "math_number"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "OP": "MINUS"
                              },
                              "id": "g*?!30,}9u9%K@BY`^ny",
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
                                    "id": "27Gj!W2OS)^aivE*15Ez",
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
                                    "id": "@rk98s`4eFZD:zEnK~ao",
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
                                  "id": "!eP)g[a]cC~||~f5TQiZ"
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
        "x": 1915,
        "y": -495
      },
      {
        "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
        "fields": {
          "NAME": "boardMethod:GetMainPlayerUnit",
          "THIS": false
        },
        "id": "1-`5h$fg#sn)IqTeK[|}",
        "next": {
          "block": {
            "id": "1OG}$Idrcvn]yp;@-xbz",
            "inputs": {
              "DO0": {
                "block": {
                  "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Duration (필수)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "boardMethod:StartTimer",
                    "THIS": false
                  },
                  "id": "-5.OXPSrj2i}|fKYf@BK",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "fields": {
                          "NUM": 1
                        },
                        "id": "qq]WtO.0{YxwpWv5]:~+",
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
                      "id": "I`4nY9-GEk$68gvJ$u@7",
                      "inputs": {
                        "VALUE": {
                          "block": {
                            "fields": {
                              "NUM": 2
                            },
                            "id": "t7Zij$PP/*NBCrDpk25J",
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
                          "id": "jN*LAa[@k$W3J6.m(fkU",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "NUM": 0
                                },
                                "id": "qIEcHM~yB=!]Q1g1IZ1R",
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
                  "id": "D6Zy#jL32%#Ew{E0H)`Y",
                  "inputs": {
                    "A": {
                      "block": {
                        "fields": {
                          "OP": "AND"
                        },
                        "id": "eH(7J2vPGyd|}6x7*Bs,",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "THIS": false,
                                "VAR": "unitVariable:HasTarget"
                              },
                              "id": "c),0;:0pohF[wdm^QzHl",
                              "type": "variables_get_reserved"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "OP": "LTE"
                              },
                              "id": "}.:Z=fPL9D]Zfi6T%c1r",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "THIS": false,
                                      "VAR": "unitVariable:TargetDistance"
                                    },
                                    "id": "E4626za`T4[$YqMVeuLo",
                                    "type": "variables_get_reserved"
                                  }
                                },
                                "B": {
                                  "block": {
                                    "fields": {
                                      "NUM": 12
                                    },
                                    "id": "5+!DYUJWKjz:Il+,I|x/",
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
                    },
                    "B": {
                      "block": {
                        "fields": {
                          "OP": "EQ"
                        },
                        "id": "B{=KU.#xP0RT78}|Gjr;",
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
                              "id": "Ti?a}!p]GvMDNld{I=1v",
                              "type": "variables_get"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "2_wh9a^?s#FTNLgsw}oT",
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
                "id": "7hdgijf2#4/_MvAvi,V8",
                "inputs": {
                  "DO0": {
                    "block": {
                      "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                      "fields": {
                        "NAME": "boardMethod:UnBlockSkillAction",
                        "THIS": false
                      },
                      "id": "+fGbk=-W5$buAYP8Z[Em",
                      "next": {
                        "block": {
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "!eP)g[a]cC~||~f5TQiZ"
                            }
                          },
                          "id": "VJ2L2*;a_n_H0_3/]Cv`",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "NUM": 3
                                },
                                "id": "tQeeb/(u)1@q6ZqNHU7I",
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
                      "id": ";Fyb@2CQL}]71c]8O@(*",
                      "inputs": {
                        "A": {
                          "block": {
                            "fields": {
                              "OP": "LTE"
                            },
                            "id": "ScDOl#)#T:P+/*^LUM46",
                            "inputs": {
                              "A": {
                                "block": {
                                  "fields": {
                                    "THIS": false,
                                    "VAR": "boardVariable:Timer"
                                  },
                                  "id": "Hj}]DB4d^[6gjlOK}-.]",
                                  "type": "variables_get_reserved"
                                }
                              },
                              "B": {
                                "block": {
                                  "fields": {
                                    "NUM": 0
                                  },
                                  "id": "SO.OKesk:,Yt,bt!Dpd6",
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
                            "id": "%VJ`76@q1I9Np;5#BV6=",
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
                                  "id": "a!97.n{u/+4G3!W|Ls@/",
                                  "type": "variables_get"
                                }
                              },
                              "B": {
                                "block": {
                                  "fields": {
                                    "NUM": 2
                                  },
                                  "id": "h[bndKhqrg?o`LFDQ-v8",
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
        "x": 1925,
        "y": 65
      },
      {
        "id": "_U%zF}B:oq/js|U!CFZP",
        "inputs": {
          "DO0": {
            "block": {
              "id": "P3hVa%B1kbJJO_P9,ojw",
              "inputs": {
                "DO0": {
                  "block": {
                    "id": "k$^[p.O/)8j1{=%t4vWK",
                    "inputs": {
                      "DO0": {
                        "block": {
                          "id": "X2Zi7`Zu5oJ$jO#tywDU",
                          "inputs": {
                            "DO0": {
                              "block": {
                                "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                "fields": {
                                  "NAME": "boardMethod:AddUnit",
                                  "THIS": true
                                },
                                "id": "1xbwoduYiHQI!/mY7;mC",
                                "inputs": {
                                  "ARG0": {
                                    "block": {
                                      "extraState": "<mutation></mutation>",
                                      "fields": {
                                        "TYPE": "board",
                                        "VAR": {
                                          "id": "=;:}4mBau:+[`,l1|E;~"
                                        }
                                      },
                                      "id": "imw:+rUp^pJ1%R_`Iu;i",
                                      "type": "variables_get"
                                    }
                                  },
                                  "ARG1": {
                                    "block": {
                                      "fields": {
                                        "VAR": "Location/SPAWNAREA_MOB_002"
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
                                      "id": "ca-Z|7;:hvij{vcqDM/H",
                                      "type": "math_number"
                                    }
                                  },
                                  "ARG5": {
                                    "block": {
                                      "fields": {
                                        "VAR": "Enemy"
                                      },
                                      "id": "z.?::y]VxhC*[{J6iSKx",
                                      "type": "teamtag_get"
                                    }
                                  },
                                  "ARG6": {
                                    "block": {
                                      "fields": {
                                        "NUM": 1
                                      },
                                      "id": "[$NMIrROs`/lq-jWm1[Z",
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
                                "id": "ycJM9uKt9qw_wW)Dl^F.",
                                "inputs": {
                                  "A": {
                                    "block": {
                                      "id": "grDJ:ObE2|Pb2^if(Cm9",
                                      "inputs": {
                                        "DIVIDEND": {
                                          "block": {
                                            "fields": {
                                              "OP": "MINUS"
                                            },
                                            "id": "[/Os$#vsEhAX^#;N%j]c",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "fields": {
                                                    "THIS": false,
                                                    "VAR": "boardVariable:Tick"
                                                  },
                                                  "id": "m4skn,wx2nQ+9g@~6nn~",
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
                                                  "id": "zn:Hx*n};$42HIQYfFuU",
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
                                            "id": "}lMEmSjj[Nk,#/!Fg9d+",
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
                                      "id": "b/0tR~TRY0b;U{U!GWfo",
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
                          "id": "Cry(66zsuZ?ekQ9DH4e{",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "OP": "MINUS"
                                },
                                "id": "f}xh3wycFBn[NUv2mk}h",
                                "inputs": {
                                  "A": {
                                    "block": {
                                      "fields": {
                                        "THIS": false,
                                        "VAR": "boardVariable:Tick"
                                      },
                                      "id": "wrSR]_d%=|XmXd1;.;-x",
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
                                      "id": "K-(/_UX!P8RPy+U~9uu4",
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
                                "id": "_9X]0mUD1+.:F%tA9`S@",
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
                    "id": "3mv$-OFyl=9[VH%Dbkq/",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "_;[4e{|wuB8/-g:_%eJA",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "THIS": false,
                                  "VAR": "boardVariable:Tick"
                                },
                                "id": "`Kb*9H|b]hBi)00oc)/M",
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
                                "id": "xsDbiUv,1`Wm[/(Nt]34",
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
                          "id": "I9p35}[)v`3]6M(6i(c5",
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
                                              "id": "ycUt=6M+|y6@%NO~V#o6"
                                            }
                                          },
                                          "id": "fPwlcdB),5s!3gO}Ai3K",
                                          "type": "variables_get"
                                        }
                                      },
                                      "ARG1": {
                                        "block": {
                                          "fields": {
                                            "VAR": "Location/SPAWNAREA_MOB_002"
                                          },
                                          "id": "JZ81b2CEY+OBV%JO=40.",
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
                                                          "id": "6ji6Z$As$U=?*^_`Bmp~"
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
                                            "NUM": 0
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
                                              "id": "6ji6Z$As$U=?*^_`Bmp~"
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
                                        "id": "6ji6Z$As$U=?*^_`Bmp~"
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
                                "NUM": 350
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
                      "id": "/A,GEUfZyv]esSPo|gOI",
                      "inputs": {
                        "DO0": {
                          "block": {
                            "id": "l;0[_{+|#=0Ak7#1#[pu",
                            "inputs": {
                              "DO0": {
                                "block": {
                                  "id": "9LS!+d#k[FEFCy5r{k];",
                                  "inputs": {
                                    "DO0": {
                                      "block": {
                                        "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                        "fields": {
                                          "NAME": "boardMethod:AddUnit",
                                          "THIS": true
                                        },
                                        "id": "qM8-LJrd5PYE`xM8)E/D",
                                        "inputs": {
                                          "ARG0": {
                                            "block": {
                                              "extraState": "<mutation></mutation>",
                                              "fields": {
                                                "TYPE": "board",
                                                "VAR": {
                                                  "id": "+~3*16N`%Hc=g}Y)-NFZ"
                                                }
                                              },
                                              "id": "zCi$8~OOvljd^9My)zkM",
                                              "type": "variables_get"
                                            }
                                          },
                                          "ARG1": {
                                            "block": {
                                              "fields": {
                                                "VAR": "Location/SPAWNAREA_MOB_002"
                                              },
                                              "id": "ka]C3aECbo#0ngTbw%wK",
                                              "type": "stringkeys_get"
                                            }
                                          },
                                          "ARG4": {
                                            "block": {
                                              "fields": {
                                                "NUM": 0
                                              },
                                              "id": "!0634jh*tL9Sv^V3p}Q}",
                                              "type": "math_number"
                                            }
                                          },
                                          "ARG5": {
                                            "block": {
                                              "fields": {
                                                "VAR": "Enemy"
                                              },
                                              "id": "VJg1D|FQjzWo(:rW7uj(",
                                              "type": "teamtag_get"
                                            }
                                          },
                                          "ARG6": {
                                            "block": {
                                              "fields": {
                                                "NUM": 1
                                              },
                                              "id": ".MVI0@8sjA0Mi?3APuvK",
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
                                        "id": "):69Kq7j)*!fF+x4nsCO",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "id": "3X(Xe8X7QZ-oFlmP)EbU",
                                              "inputs": {
                                                "DIVIDEND": {
                                                  "block": {
                                                    "fields": {
                                                      "OP": "MINUS"
                                                    },
                                                    "id": "w~zuwonD_`NLA!U~iY]u",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "fields": {
                                                            "THIS": false,
                                                            "VAR": "boardVariable:Tick"
                                                          },
                                                          "id": "@~l3cU:xh5MUpQpv-5._",
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
                                                          "id": "Yb3|$Es|A_Ms{7jwgJdj",
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
                                                    "id": ")+9KV//kEjCGjbc640~3",
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
                                              "id": "HU6`U!3Os*)6yJ]IzwC)",
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
                                  "id": "#q9FmT{zeE0n~sbg/Hbl",
                                  "inputs": {
                                    "A": {
                                      "block": {
                                        "fields": {
                                          "OP": "MINUS"
                                        },
                                        "id": ":reQdy,U-yT|RXs}zKY.",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "THIS": false,
                                                "VAR": "boardVariable:Tick"
                                              },
                                              "id": "g0#y`Wti+GR5S[th0*eO",
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
                                              "id": "(SKEcjUIpJ@[?y#=JTVD",
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
                                        "id": "$=C)*-]an((AS+c/JZ,R",
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
                            "id": "H6d{J3xjRDQL/zZkQTCo",
                            "inputs": {
                              "A": {
                                "block": {
                                  "fields": {
                                    "OP": "MINUS"
                                  },
                                  "id": "3}XdiGly_hGa1P{hdb_e",
                                  "inputs": {
                                    "A": {
                                      "block": {
                                        "fields": {
                                          "THIS": false,
                                          "VAR": "boardVariable:Tick"
                                        },
                                        "id": "0BXER[bR~nZVHpjek@jp",
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
                                        "id": ",NLm]:*e7u!}D:GR4AsO",
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
                                    "NUM": 900
                                  },
                                  "id": "W.!O|/a%V*_0Fz0|S!5p",
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
                                    "id": "!eP)g[a]cC~||~f5TQiZ"
                                  }
                                },
                                "id": "9aaeIzAm{km(t=ME-x%q",
                                "inputs": {
                                  "VALUE": {
                                    "block": {
                                      "fields": {
                                        "NUM": 4
                                      },
                                      "id": "l.TE~8,7`x#a-I][=k~l",
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
                                                  "id": ";cb}HfaPRr]OpbrI5+h*"
                                                }
                                              },
                                              "id": "uEf/Z#?`b6+!g`!+[C-j",
                                              "type": "variables_get"
                                            }
                                          },
                                          "ARG1": {
                                            "block": {
                                              "fields": {
                                                "VAR": "Location/SPAWNAREA_MOB_002"
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
                                                "id": "UZFG;J)4/H^Z-%{m?L$v"
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
                                          "id": "haV+evEyYXpN85{NOBM_"
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
              "id": "eYZ/?-L/oJb[_XVJLwWI",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "GTE"
                    },
                    "id": "#.$.+W)3g;pB7hd{D..[",
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
                          "id": "s#1Nm1V{nYVZT?pG!i@v",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "1PGj!7UB.6(~YL@NLyFz",
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
                    "id": "85waph]TFt4}Ct5%d2RN",
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
                          "id": "J3^6.A$NNsZ4Ty_3=@n!",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 3
                          },
                          "id": "%dFu}[~y6EXFyAS}n_z}",
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
        "x": 1915,
        "y": 475
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
                      "TYPE": "board",
                      "VAR": {
                        "id": "UZFG;J)4/H^Z-%{m?L$v"
                      }
                    },
                    "id": "]FXCdw.!RzVUb:%0@EYh",
                    "inputs": {
                      "VALUE": {
                        "block": {
                          "fields": {
                            "NUM": 0
                          },
                          "id": "ELFY+IHpO}bW42`f6omE",
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
                        "id": "t:NCj{}K4D-,|:!;W=bk",
                        "inputs": {
                          "ARG0": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": "XuvHHbTtLq{rys|J[/]L"
                                }
                              },
                              "id": "6L5mjl4KL]FTDfQfR]U:",
                              "type": "variables_get"
                            }
                          },
                          "ARG1": {
                            "block": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "s`^@5:cAp_VD2Q;(TWX]",
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
                                      },
                                      "VAR": {
                                        "block": {
                                          "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;현재 wave단계 입력&quot;,&quot;name&quot;:&quot;Level&quot;}]\"></mutation>",
                                          "fields": {
                                            "NAME": "boardMethod:StartWaveEndSelectTrait",
                                            "THIS": false
                                          },
                                          "id": "FYk?+j.`[PrI[?8fan[G",
                                          "inputs": {
                                            "ARG0": {
                                              "block": {
                                                "fields": {
                                                  "NUM": 2
                                                },
                                                "id": "qMouP=p%Q?*6ae,UtNxS",
                                                "type": "math_number"
                                              }
                                            }
                                          },
                                          "type": "function_call_return"
                                        }
                                      }
                                    },
                                    "next": {
                                      "block": {
                                        "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                                        "fields": {
                                          "NAME": "boardMethod:ShowSelectTrait",
                                          "THIS": false
                                        },
                                        "id": "zKM;y?[2AE?=+uYL7uU%",
                                        "next": {
                                          "block": {
                                            "fields": {
                                              "TYPE": "board",
                                              "VAR": {
                                                "id": "Ek:5yv3s|PF-]xi{ROQM"
                                              }
                                            },
                                            "id": "?`y.bp5e7p#W_+7YI}$w",
                                            "inputs": {
                                              "VALUE": {
                                                "block": {
                                                  "fields": {
                                                    "OP": "ADD"
                                                  },
                                                  "id": "l#)%14q:~Og82m4zQ,[m",
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
                                                        "id": "07[dOd0xcE;?Ip^|kxf]",
                                                        "type": "variables_get"
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
                                                          "NUM": 1
                                                        },
                                                        "id": "Nvn22JJqwM_?sK3;)F`T",
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
                                                "fields": {
                                                  "TYPE": "board",
                                                  "VAR": {
                                                    "id": "!eP)g[a]cC~||~f5TQiZ"
                                                  }
                                                },
                                                "id": ",Tj$/agHxn^]q]NflXPr",
                                                "inputs": {
                                                  "VALUE": {
                                                    "block": {
                                                      "fields": {
                                                        "NUM": 0
                                                      },
                                                      "id": "WW8efY}ZRBFMJ.{|h}1{",
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
                                                    "id": "?PEx+)]/:2lCp%wl/aBf",
                                                    "inputs": {
                                                      "VALUE": {
                                                        "block": {
                                                          "fields": {
                                                            "NUM": 1
                                                          },
                                                          "id": "DcgW(xY?ll6/=z*o%h_~",
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
                                            "type": "variables_set"
                                          }
                                        },
                                        "type": "function_call"
                                      }
                                    },
                                    "type": "debug"
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
                                    "id": ";cb}HfaPRr]OpbrI5+h*"
                                  }
                                },
                                "id": "[5XgBQajl)kL8~,S*;$1",
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
                        "id": "UZFG;J)4/H^Z-%{m?L$v"
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
        "x": 1895,
        "y": 2335
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Map_Default3_MidBoss_Wave2",
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
      "id": "UPq68+v1`W@R`#E~Z6FB",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "u9.^Ofy|.0_{^29pq+(G",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "9O-w@bZefW)Ys)+`IRy-",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "z|M:6bJ8?+|[K9O#}8Qb",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "^P((oN7;r=@/b`..UOCP",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "FN?6N(BMX0~[p;lQvB6%",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "]*cI/I.K=t{)S11u-RxR",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "jI7?.KFoS~rAE|$??9GS",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "}n:68@v;c{QV%wv!F|*O",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "88JNQf0XuMr|qRl55`I4",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "TM%yEQ(s|vclbNdp$Q~%",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "jrQQak%g_Yny!Tk6itt=",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "n+0sn{:N5NL62:sv6WS)",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "R~0#e(aT@~40Oi-mUdq+",
      "name": "@Map/Progress"
    },
    {
      "id": "EmGw.l4wpo3(djYWVM~~",
      "name": "Map/DisplayWinningTeam"
    },
    {
      "id": "E8cIp:Ie[xQs=-_*[/]P",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "~7^]g~lMt^J-,?XE/f8n",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "7{;(MS-oQ:-:dKhmgf]E",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "d%_+R?tJaI5NDiG~j96J",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "u;[r1OgKx!wv22pVA(fy",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "9NJ!QYOD=`So%`F}^}-k",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "Gd)zIJ;D4__%]ntp^ZcK",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "xIW*wgD.`xLR]3Vh{v@?",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "4pQ7!cNnxD$T~wPVqHw[",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "db;e8]W.x10d-OCbs:xm",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "BJidbhn=@K@_w*otM,G.",
      "name": "@Skill/Variable/10"
    }
  ]
}