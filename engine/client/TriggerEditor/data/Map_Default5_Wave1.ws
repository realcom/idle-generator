{
  "blocks": {
    "blocks": [
      {
        "fields": {
          "NAME": "Map_Default5_Wave2",
          "THIS": true
        },
        "id": "U)a;=BEs#,=l(htM#nfX",
        "next": {
          "block": {
            "fields": {
              "NAME": "Map_Default5_Wave3",
              "THIS": true
            },
            "id": "tqf4}.J~NnK,nqUY.KJr",
            "next": {
              "block": {
                "fields": {
                  "NAME": "Map_Default5_Wave4",
                  "THIS": true
                },
                "id": "8j./;Tgn!9K-Nj5jQ.m3",
                "next": {
                  "block": {
                    "fields": {
                      "NAME": "Map_Default5_Wave5",
                      "THIS": true
                    },
                    "id": "iOLFM`bUHF}X#JFA=ry{",
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
                                                  "id": "$gv[e8PHyrlmWo-S#cMH"
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
                "type": "trigger_call"
              }
            },
            "type": "trigger_call"
          }
        },
        "type": "trigger_call",
        "x": 815,
        "y": -4065
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
        "x": 785,
        "y": 435
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
                              "id": "$gv[e8PHyrlmWo-S#cMH"
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
                        "id": "$V%?z:h+LJLQ+f0+H8IR",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "THIS": false,
                                "VAR": "unitVariable:HasTarget"
                              },
                              "id": "ow}/{Vegzi.S7^.GG4-0",
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
        "x": 805,
        "y": -2695
      },
      {
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
                      "TEXT": "Default5_Battle_01_01"
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
                  "id": "]%BoHk-SbF9)^Mkqt_`V",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "fields": {
                          "NUM": 3
                        },
                        "id": "^d%wp(RC{moxHuj`Z(l;",
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
                                            "NUM": 1800
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
                                      "id": "?QC}vwIZ%3n)3wC0y(]H",
                                      "inputs": {
                                        "VALUE": {
                                          "block": {
                                            "fields": {
                                              "BOOL": "TRUE"
                                            },
                                            "id": "w.$WCV0ZRsolH9R%$@T)",
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
                "OP": "AND"
              },
              "id": "om-?U^JU|@UPp7q`%cNm",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "%/n;CV,i#ibgL66lSd$:",
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
                          "id": "{mpN2ghi6kw%0-h2my|V",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "BOOL": "FALSE"
                          },
                          "id": "*.s8RZBz6@Ijlt(hJAe*",
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
        "next": {
          "block": {
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
            "type": "controls_if"
          }
        },
        "type": "controls_if",
        "x": 815,
        "y": -3645
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
                                      "id": "y?}{@6a_2TcYN3`/U4xQ",
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
                                            "id": "`MRbdK/au|eFqQQL#zDZ",
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
                                            "id": "+lzAUWh$%Q=^9tcF1/T[",
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
                                                  "id": "Y{58Ov6imX42%NQk:;WQ",
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
                                                  "id": "=s-?m(AnQx?@Mpzrksmg",
                                                  "inputs": {
                                                    "A": {
                                                      "block": {
                                                        "fields": {
                                                          "OP": "ADD"
                                                        },
                                                        "id": "6-r.:E04MMS7Oo$^JMA)",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "fields": {
                                                                "THIS": false,
                                                                "VAR": "unitVariable:VelocityX"
                                                              },
                                                              "id": "qGW(@Ds/R,#ACVu`G70F",
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
                                                              "id": "sVMJ,my*/.$iqv4$FwR(",
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
                                                        "id": "6v}wOafjVG*c$yK|vYkl",
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
                                              "id": "lb3Lgh^3uRiyQ!OJr^e*"
                                            }
                                          },
                                          "id": "N{?/=`0FuOgCwVVs[m?c",
                                          "type": "variables_get"
                                        }
                                      },
                                      "ARG2": {
                                        "block": {
                                          "fields": {
                                            "OP": "ADD"
                                          },
                                          "id": "V6.6Wx7lefCKwyE/F_[3",
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
                                                "id": "a={O6t[.zeqZ@+4ti#A#",
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
                                                "id": "fx5#+ZK.W+#]|:(_x$87",
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
                                                      "id": ",q;,OS}X#Wco`7{|N2i+",
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
                                                      "id": "+DzG7!M7[e(NQ*)Wf:Mo",
                                                      "inputs": {
                                                        "A": {
                                                          "block": {
                                                            "fields": {
                                                              "OP": "ADD"
                                                            },
                                                            "id": "yCSBH[]Je-dI2r0NZTt|",
                                                            "inputs": {
                                                              "A": {
                                                                "block": {
                                                                  "fields": {
                                                                    "THIS": false,
                                                                    "VAR": "unitVariable:VelocityX"
                                                                  },
                                                                  "id": "L*|Wo~Bsn6j:L~,LE2?E",
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
                                                                  "id": "@=](bQpks:x+ieYs#sOx",
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
                                                            "id": "o~A:y(J;=nDo=qv0zVyT",
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
                                      "NUM": 1800
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
                                "NUM": 195
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
                      "id": "Pkkyjt/ahjTg$F_2TtLn",
                      "inputs": {
                        "DO0": {
                          "block": {
                            "id": "T1ZI8/u[*)TPp6.7iC@Q",
                            "inputs": {
                              "DO0": {
                                "block": {
                                  "id": "E1yh:8e^jb}^4kTN*9T(",
                                  "inputs": {
                                    "DO0": {
                                      "block": {
                                        "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                        "fields": {
                                          "NAME": "boardMethod:AddUnit",
                                          "THIS": true
                                        },
                                        "id": "@,.PIf#,L$|TD]2c`g}5",
                                        "inputs": {
                                          "ARG0": {
                                            "block": {
                                              "extraState": "<mutation></mutation>",
                                              "fields": {
                                                "TYPE": "board",
                                                "VAR": {
                                                  "id": "/(;L7)])x+I%LUTTX03T"
                                                }
                                              },
                                              "id": "]Q{.An}yp5!61XypBvKD",
                                              "type": "variables_get"
                                            }
                                          },
                                          "ARG2": {
                                            "block": {
                                              "fields": {
                                                "OP": "ADD"
                                              },
                                              "id": "d3`*Dr5t!hR^d$IROOxD",
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
                                                    "id": "Kc`RB-SJ)$Jr,T!,AvFA",
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
                                                    "id": "c9!PrnV|8@r5SP*aWgHN",
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
                                                          "id": "EA6X~YxviG-h^PZ+q!(V",
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
                                                          "id": "$Vmu{p_0.vMx:gu/fKmN",
                                                          "inputs": {
                                                            "A": {
                                                              "block": {
                                                                "fields": {
                                                                  "OP": "ADD"
                                                                },
                                                                "id": "IeIA+:hoac`|9*m3`Z`{",
                                                                "inputs": {
                                                                  "A": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "THIS": false,
                                                                        "VAR": "unitVariable:VelocityX"
                                                                      },
                                                                      "id": "0*WZEA`h#Zcw9@nMTz@p",
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
                                                                      "id": "9c,w3x)0jm;(,)*7#G%)",
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
                                                                "id": "5t:-8.-bF?pg_ay9*E`R",
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
                                              "id": "CFkS[(u#hLIhXzrO*RF;",
                                              "type": "math_number"
                                            }
                                          },
                                          "ARG5": {
                                            "block": {
                                              "fields": {
                                                "VAR": "Enemy"
                                              },
                                              "id": "[Aa4Zcl#G-XzJ$iM~8=]",
                                              "type": "teamtag_get"
                                            }
                                          },
                                          "ARG6": {
                                            "block": {
                                              "fields": {
                                                "NUM": 1
                                              },
                                              "id": "{qp/ALTdp*C$e{){72,?",
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
                                        "id": "/FK|ZDRuTh`}A_!PkEg4",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "id": "6C14+bPmJ2jA;j`=i$%P",
                                              "inputs": {
                                                "DIVIDEND": {
                                                  "block": {
                                                    "fields": {
                                                      "OP": "MINUS"
                                                    },
                                                    "id": "2hXrJD:NPjYZfxJKM|#H",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "fields": {
                                                            "THIS": false,
                                                            "VAR": "boardVariable:Tick"
                                                          },
                                                          "id": "%bNy^A.mRGQqH3mY{AUd",
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
                                                          "id": "lOmlxr@k!Q?K4mmxaqmc",
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
                                                    "id": "FyWbU?(Pft,!}}P^7u`W",
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
                                              "id": "FN(L(.E8c-f9X8O#v$:o",
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
                                  "id": "I*BNOKV;G$3xjeqZvjPr",
                                  "inputs": {
                                    "A": {
                                      "block": {
                                        "fields": {
                                          "OP": "MINUS"
                                        },
                                        "id": "}*9QgVGC=vZxt=+uLaUw",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "THIS": false,
                                                "VAR": "boardVariable:Tick"
                                              },
                                              "id": "xxN@MQU3UAKJ^=g`)~)C",
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
                                              "id": ")4#F2pN{91z.ON0!K|y!",
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
                                        "id": "Swy|Cy;AFEHBKULm6n3e",
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
                            "id": "aciiI#5.|rDjgl%KgZ]Z",
                            "inputs": {
                              "A": {
                                "block": {
                                  "fields": {
                                    "OP": "MINUS"
                                  },
                                  "id": "6}T3!evIHBMY%7`A%UYt",
                                  "inputs": {
                                    "A": {
                                      "block": {
                                        "fields": {
                                          "THIS": false,
                                          "VAR": "boardVariable:Tick"
                                        },
                                        "id": "@HEaCXGBtnm|CRE@Ub%n",
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
                                        "id": "QCsE;o~Q(c@R^KdQmvP7",
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
                                  "id": ")Sri{DIb7(2/rbCAeF^J",
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
                          "id": "@},p2(p6;*~ICFC,4)P7",
                          "inputs": {
                            "DO0": {
                              "block": {
                                "id": "}#l7BBa.zi9_l-.@0w+(",
                                "inputs": {
                                  "DO0": {
                                    "block": {
                                      "id": "P5l~59;AD8ew4j!=pf$|",
                                      "inputs": {
                                        "DO0": {
                                          "block": {
                                            "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                            "fields": {
                                              "NAME": "boardMethod:AddUnit",
                                              "THIS": true
                                            },
                                            "id": "z.8g]O8.{:*VxR(Ui2Zf",
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
                                                  "id": "VEZ:(?dJzkOxB]?:jF5f",
                                                  "type": "variables_get"
                                                }
                                              },
                                              "ARG2": {
                                                "block": {
                                                  "fields": {
                                                    "OP": "ADD"
                                                  },
                                                  "id": "Zl3shTb3s!~p,)R;U)IM",
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
                                                        "id": "1rU{FG5Yca]/`1Bi_jHx",
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
                                                        "id": "!yptEEEL}utazkr@;}qc",
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
                                                              "id": ".AREyB9=-+:BBa~E8pZ#",
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
                                                              "id": "%Y,qNWcPl7iBW%SDi7aJ",
                                                              "inputs": {
                                                                "A": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "OP": "ADD"
                                                                    },
                                                                    "id": ")#8]t9pEY`l*S[m/2Jgk",
                                                                    "inputs": {
                                                                      "A": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "THIS": false,
                                                                            "VAR": "unitVariable:VelocityX"
                                                                          },
                                                                          "id": "{qLAPAfl_[d$BeR}C*gH",
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
                                                                          "id": "{wSq~afG}5VAwO[*G5mm",
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
                                                                    "id": "/hS1`qHav)bb!T2iL:ZA",
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
                                                  "id": "i}TNo-Z^Cz)@*r:z^Miz",
                                                  "type": "math_number"
                                                }
                                              },
                                              "ARG5": {
                                                "block": {
                                                  "fields": {
                                                    "VAR": "Enemy"
                                                  },
                                                  "id": "PqGwbw5f=bFbL4oVnIfh",
                                                  "type": "teamtag_get"
                                                }
                                              },
                                              "ARG6": {
                                                "block": {
                                                  "fields": {
                                                    "NUM": 1
                                                  },
                                                  "id": "M?}E#l|{1i1cMcGg})x.",
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
                                            "id": "cMN:`Y^7emX8d(UebqQ(",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "id": "0!%||]8gj502?5VwbRg;",
                                                  "inputs": {
                                                    "DIVIDEND": {
                                                      "block": {
                                                        "fields": {
                                                          "OP": "MINUS"
                                                        },
                                                        "id": "{Ftf}%C-LS_P]o~5!xFI",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "fields": {
                                                                "THIS": false,
                                                                "VAR": "boardVariable:Tick"
                                                              },
                                                              "id": "1Y$u#dNI2N:W,L]wINq-",
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
                                                              "id": "ZrH%(scLEMula28AZ2Cp",
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
                                                        "id": "S`.z}*/5O+uXrlyaqECh",
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
                                                  "id": "c`2t)iuWL[O5DOR+c6H=",
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
                                      "id": "_Wc5yJAe_vsSlI|gci@a",
                                      "inputs": {
                                        "A": {
                                          "block": {
                                            "fields": {
                                              "OP": "MINUS"
                                            },
                                            "id": "tmvbao+pdPdW9LC?0ajJ",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "fields": {
                                                    "THIS": false,
                                                    "VAR": "boardVariable:Tick"
                                                  },
                                                  "id": "7u+tl!F,?,Le~CN9iqlF",
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
                                                  "id": "!F`Qw+p7X*0|n(`l~R0K",
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
                                            "id": "D%EYULG,igmxO`dPPG[O",
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
                                "id": "Ub:L0VvU)a6/T(2-H$*S",
                                "inputs": {
                                  "A": {
                                    "block": {
                                      "fields": {
                                        "OP": "MINUS"
                                      },
                                      "id": "rH7lar~j91a|uVOXg/dQ",
                                      "inputs": {
                                        "A": {
                                          "block": {
                                            "fields": {
                                              "THIS": false,
                                              "VAR": "boardVariable:Tick"
                                            },
                                            "id": "9T.5p(t$y#aJGG(m0K@%",
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
                                            "id": "~,te~TGzywi.K_I*b}YB",
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
                                      "id": "EBLsi4UkPaB3_deZ$[Sk",
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
                              "id": "[B?hgPZSNt$W,=vhI]-?",
                              "inputs": {
                                "DO0": {
                                  "block": {
                                    "id": "5$cT-mGybN2M*$$6C;5y",
                                    "inputs": {
                                      "DO0": {
                                        "block": {
                                          "id": "x%$M23AC#Rp?6glY%xLH",
                                          "inputs": {
                                            "DO0": {
                                              "block": {
                                                "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                "fields": {
                                                  "NAME": "boardMethod:AddUnit",
                                                  "THIS": true
                                                },
                                                "id": "FvI1q:|KxJ|x^nBtuxf@",
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
                                                      "id": "^Ir20.9-nu}.RpNtay%Y",
                                                      "type": "variables_get"
                                                    }
                                                  },
                                                  "ARG2": {
                                                    "block": {
                                                      "fields": {
                                                        "OP": "ADD"
                                                      },
                                                      "id": "astXHDin8=o0?[bhGO90",
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
                                                            "id": "ZToXMwxrB@_y`)m.Yo8o",
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
                                                                  "id": "PAhh6zaEL:/K1F-K2]1B",
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
                                                                  "id": "fYR;Ms]TCNH1~^u8XMGv",
                                                                  "inputs": {
                                                                    "A": {
                                                                      "block": {
                                                                        "fields": {
                                                                          "OP": "ADD"
                                                                        },
                                                                        "id": "]sIh,aH[GO/k!I]Q{3f3",
                                                                        "inputs": {
                                                                          "A": {
                                                                            "block": {
                                                                              "fields": {
                                                                                "THIS": false,
                                                                                "VAR": "unitVariable:VelocityX"
                                                                              },
                                                                              "id": "u_L24[QTKTgMssW|}|w=",
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
                                                                              "id": "%i@AMP)OYjosL14Y$KWb",
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
                                                                        "id": "8/Tq+|{:Zw0_w1J![2)!",
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
                                                      "id": "5XE`Yg#lv/w@v+m3+ZQq",
                                                      "type": "math_number"
                                                    }
                                                  },
                                                  "ARG5": {
                                                    "block": {
                                                      "fields": {
                                                        "VAR": "Enemy"
                                                      },
                                                      "id": "#PPV^St9dOpL118r:Fdg",
                                                      "type": "teamtag_get"
                                                    }
                                                  },
                                                  "ARG6": {
                                                    "block": {
                                                      "fields": {
                                                        "NUM": 1
                                                      },
                                                      "id": ",X)cQhY/vz#]xba5~,`;",
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
                                                "id": "%fclQ^SuSOY38?cy4UD!",
                                                "inputs": {
                                                  "A": {
                                                    "block": {
                                                      "id": "1^ss2_Y/_Of2^INX=ZGf",
                                                      "inputs": {
                                                        "DIVIDEND": {
                                                          "block": {
                                                            "fields": {
                                                              "OP": "MINUS"
                                                            },
                                                            "id": "-5mP+Wb.d)alyKLniE5_",
                                                            "inputs": {
                                                              "A": {
                                                                "block": {
                                                                  "fields": {
                                                                    "THIS": false,
                                                                    "VAR": "boardVariable:Tick"
                                                                  },
                                                                  "id": "I~d:**4@fXnuoYN4Q3aO",
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
                                                                  "id": "b{rS/)BgxrO2q}Inpo87",
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
                                                            "id": "x5o$QVy$HRV[eV$6gX,#",
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
                                                      "id": "swgx1BESyRrlXqv/-!=|",
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
                                          "id": "``N+R.EEsNmhk._@g:u|",
                                          "inputs": {
                                            "A": {
                                              "block": {
                                                "fields": {
                                                  "OP": "MINUS"
                                                },
                                                "id": "u@k0*qE9K=83[-K0q[K4",
                                                "inputs": {
                                                  "A": {
                                                    "block": {
                                                      "fields": {
                                                        "THIS": false,
                                                        "VAR": "boardVariable:Tick"
                                                      },
                                                      "id": "jc#m[49mTsVl-,/c.~sM",
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
                                                      "id": "+#AK=`}.#[FF$|?+I`kt",
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
                                                "id": "TEe7w56,86feyG8[@NrG",
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
                                    "id": "L[GhPwx7US/b=cvb_i5=",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "fields": {
                                            "OP": "MINUS"
                                          },
                                          "id": "QY8yudrMY9sx$$PMZdN)",
                                          "inputs": {
                                            "A": {
                                              "block": {
                                                "fields": {
                                                  "THIS": false,
                                                  "VAR": "boardVariable:Tick"
                                                },
                                                "id": "P%A)*@+;`@g9}g02Afg#",
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
                                                "id": "S;`rd5DJ~IX:s(]2wOnt",
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
                                            "NUM": 1395
                                          },
                                          "id": "%}YxKKAQ#{2Z][:YnprH",
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
              "id": "N=@QEV[.#Y4D$G%T[3SG",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "GTE"
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
                            "NUM": 1
                          },
                          "id": "iZP.q)VY?UAjW2?Wb`Ql",
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
                    "id": "qZN_g0eK;EjvP2p!X0ix",
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
                          "id": "bTry=3V=b=BT#(ooe?jw",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 3
                          },
                          "id": "%]e+d)ME[Vj833,m{SzR",
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
        "x": 785,
        "y": -2215
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
        "x": 805,
        "y": -2995
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Map_Default5_Wave1",
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
      "id": "X1:+nWJk?rw79A`EtN)U",
      "name": "Zem"
    },
    {
      "id": "pfCdwIC%UTeV2CWk#-:_",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "T^r:_*BD0q2}xHC,w*sj",
      "name": "Gem"
    },
    {
      "id": "ui`(wJIEw$]Ict;TVxLr",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": ";LDl02Q[{konm:X6hRc6",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "5/o3056/1EohY?@fIA|K",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "e5.NaZB}p|76Z@3U{jpw",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "/SV+P0S3vO[4e5:M+qc}",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "KA+u9B~4O..X-`LH(sD-",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "LQ0~xQ*rVl5U|11R!lbT",
      "name": "Map/CanStart"
    },
    {
      "id": "n+laj[=K5{7p(FpgX+Z^",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "$gv[e8PHyrlmWo-S#cMH",
      "name": "Map/Player/Moving"
    },
    {
      "id": "gKtv(OII6On)h=j]TZM,",
      "name": "@Map/Player/Moving"
    },
    {
      "id": "MBOID`HCN+O/aJ=|HDrH",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "a_IYG+h_Mta%J^[(KnnL",
      "name": "@Buff/Variable/08"
    },
    {
      "id": ":Q2*Xo7Sjm!nr]PZCg{a",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "o|W}|t![UY54/S*=Zg^`",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "nDr.BP8NC]xt0GN)Z(:U",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "73`T]fn?6GANf;}dJSL)",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "L`H@fn!AFk1CLLE_.hc3",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "Y~Vo_Ld0@GI0_(q7Z}Bs",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "k4::}P.28/!Au4HV~+hB",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "U}$4YiM!qYT;i`?:s!Ti",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "_,E.mA=m;2ladHnf-xp$",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "{(iD+;9LaX+2X#Cbl33A",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": ":G5L)B}|p)eauGHBSjAq",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "+olCE[mh`xCZ5l_~2b%$",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "]46+f*Ep,:-Ah/%rxw{|",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "l.hMaQ$-M]*ApQS|mHq2",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "UdTr2V~V$c5xgS}w{M{`",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "CFOd=v4G0l$W)%w7@ifB",
      "name": "@Map/Progress"
    },
    {
      "id": "g!??.m*+f5qQ/%C:?I*/",
      "name": "Map/DisplayWinningTeam"
    },
    {
      "id": "M)0ZtY;tI4Y3{XgQr}2A",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "W+w#Zcy]8T0eMe)7SZD6",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "l{B)V8oi=iHn=O//bu`B",
      "name": "@Skill/Variable/06"
    },
    {
      "id": ".MxvJwHki~bgSh*qeAru",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "`*%t*gN}Yb2dh:p]E#2p",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "VjY/aYk`LutVgo04%!.2",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "?TAz2gy~iiC3%a{Nw{:4",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "rgdc_,-.NQr[!F|q_`|a",
      "name": "🚨 Scout rewards maxed out!\nCollect Gold💰 & Gems💎, and power up!\nPlay Hamster Combat now! 👉 [Play Now]"
    },
    {
      "id": "(?EW|28mk9IFufs@#K.I",
      "name": "@Map/WaveStartPlayerPosition"
    }
  ]
}