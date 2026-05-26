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
        "type": "controls_if",
        "x": 675,
        "y": -3685
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
                      "TEXT": "Default4_Battle_03_01"
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
                  "id": "%TJT*a_ugdxSj0RrYm]$",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "fields": {
                          "NUM": 2
                        },
                        "id": "@,3g_3+?D*32a}l61(]8",
                        "type": "math_number"
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
                    "id": "tS|NFvDL+jQ)gdhB7#I0",
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
        "type": "controls_if",
        "x": 665,
        "y": -3435
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
            "id": "DN$Pz}wTRvcIjQOz~F`g",
            "inputs": {
              "DO0": {
                "block": {
                  "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Duration (필수)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "boardMethod:StartTimer",
                    "THIS": false
                  },
                  "id": "AvEnRPP(@I];v.x5p,CT",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "fields": {
                          "NUM": 1
                        },
                        "id": "TR(XU0.zBqnM`/aL]IaQ",
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
                      "id": "UJ{5@o:8OwWP_8nz9O-X",
                      "inputs": {
                        "VALUE": {
                          "block": {
                            "fields": {
                              "NUM": 2
                            },
                            "id": "vtoa93)fv{9U:uye]U`a",
                            "type": "math_number"
                          }
                        }
                      },
                      "next": {
                        "block": {
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "6h@1b(PI/xwghc`}+Ldl"
                            }
                          },
                          "id": "0KAzi!fNZMZ^?j~j8n*-",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "NUM": 0
                                },
                                "id": "0.})24h!S52OoDwL$tmf",
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
                  "id": "w%WOzTCZH5aL8V,{QF0,",
                  "inputs": {
                    "A": {
                      "block": {
                        "fields": {
                          "OP": "AND"
                        },
                        "id": ";}Y(bHQ$bpp~;9H_|Edu",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "THIS": false,
                                "VAR": "unitVariable:HasTarget"
                              },
                              "id": "[;g0oQV(GOOVN/:DL[);",
                              "type": "variables_get_reserved"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "OP": "LTE"
                              },
                              "id": "H;Do*!MpwoxiAV]:aQBn",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "THIS": false,
                                      "VAR": "unitVariable:TargetDistance"
                                    },
                                    "id": "4ZLxQt_|Il%lAp/0L4sE",
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
                        "id": "IOI@0z$0@%nGxJQ(/Ol-",
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
                              "id": "k/O1.2V?sGt8v%Ii8]l0",
                              "type": "variables_get"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "I|nSNwHtJ2}mR{lhW.oY",
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
                "id": "OWgk-o2Z[7%S.,i(f+Qb",
                "inputs": {
                  "DO0": {
                    "block": {
                      "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                      "fields": {
                        "NAME": "boardMethod:UnBlockSkillAction",
                        "THIS": false
                      },
                      "id": ".;pxEl]gk:q4hssbiHDW",
                      "next": {
                        "block": {
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "F//i`5m5GJ/iAUoeO`l["
                            }
                          },
                          "id": "atSC[=wMJ9*ly{]Q)Z^g",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "NUM": 3
                                },
                                "id": "9W}!m]ej:,5qDXceGWpY",
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
                      "id": "{%/1[4z`1i.Tn;.e?-dH",
                      "inputs": {
                        "A": {
                          "block": {
                            "fields": {
                              "OP": "LTE"
                            },
                            "id": "d?gH~M?AdDWmJ*JSQYI=",
                            "inputs": {
                              "A": {
                                "block": {
                                  "fields": {
                                    "THIS": false,
                                    "VAR": "boardVariable:Timer"
                                  },
                                  "id": "va#tDhd^D7;h+XG*|84)",
                                  "type": "variables_get_reserved"
                                }
                              },
                              "B": {
                                "block": {
                                  "fields": {
                                    "NUM": 0
                                  },
                                  "id": "0~x5Yqp7mzeWrYzW{B{U",
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
                            "id": "s_Y~nW{$3T-||lm2w_mr",
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
                                  "id": "_iF/QoCoI}ZWw9vW;F}(",
                                  "type": "variables_get"
                                }
                              },
                              "B": {
                                "block": {
                                  "fields": {
                                    "NUM": 2
                                  },
                                  "id": "7#?IiRU(W[S0L3ge~,50",
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
        "x": 645,
        "y": -2355
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
                                    "id": "zP9v=6@H_Fow55U(;_=g"
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
                            "NUM": 1230
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
                  "id": "/JIg)jweMB3]YSL]zEo3",
                  "inputs": {
                    "DO0": {
                      "block": {
                        "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                        "fields": {
                          "NAME": "boardMethod:ShowPopup",
                          "THIS": false
                        },
                        "id": "#s73i.vvp~k!05Sj5PT`",
                        "inputs": {
                          "TEXT": {
                            "block": {
                              "fields": {
                                "TEXT": "Popup_BigWaveAlert"
                              },
                              "id": "aBF*3I=E!34MQJa3XG{M",
                              "type": "text"
                            }
                          },
                          "VAR1": {
                            "block": {
                              "fields": {
                                "NUM": 0
                              },
                              "id": "%8b!Hn8##hhQWN=_%9U$",
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
                        "id": "#fZ[T{l24Qgea1Fk,dd6",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "OP": "MINUS"
                              },
                              "id": "mVsn`%]L;Dm|n,46NZC8",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "THIS": false,
                                      "VAR": "boardVariable:Tick"
                                    },
                                    "id": ")RCg5*^Hf[N-JwV=sFkb",
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
                                    "id": "S#Ig==.9zT70q.uwM1t[",
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
                                "NUM": 2040
                              },
                              "id": "M;:TG(:rjoc7(J51A_uA",
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
                                                  "id": "z5hH`n~?0Vp,}W/9B=X4"
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
                                                              "id": "jKYHQM:)v@h,zTna;:Zi"
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
                                                      "id": ";8#e-4(y0VYZXfwXDhTB"
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
                                                  "id": "b1=u]D%:|%z7k8iczJuL",
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
                                                        "id": "|aqaW~{-t_pYKDbvBSf(",
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
                                                        "id": "GHpSA.)CQ:7E=UO*B#J1",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "extraState": "<mutation></mutation>",
                                                              "fields": {
                                                                "TYPE": "board",
                                                                "VAR": {
                                                                  "id": "jKYHQM:)v@h,zTna;:Zi"
                                                                }
                                                              },
                                                              "id": "#D!r]:=P8k@jOe(o5,7|",
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
                                                              "id": "d?~XFb3go(x2_WeTb|_p",
                                                              "inputs": {
                                                                "A": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "OP": "ADD"
                                                                    },
                                                                    "id": "+GWN0m|3{ir_;hwX;kn2",
                                                                    "inputs": {
                                                                      "A": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "THIS": false,
                                                                            "VAR": "unitVariable:VelocityX"
                                                                          },
                                                                          "id": "4d-`JRIrQQl#vARLZ|1;",
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
                                                                          "id": "LP|-5#-69ZUb(NPxRZS;",
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
                                                                    "id": "TBe-1x{I*T6K2?m$Iu-j",
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
                                                          "NUM": 525
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
                                                          "id": ";8#e-4(y0VYZXfwXDhTB"
                                                        }
                                                      },
                                                      "id": "zCi$8~OOvljd^9My)zkM",
                                                      "type": "variables_get"
                                                    }
                                                  },
                                                  "ARG2": {
                                                    "block": {
                                                      "fields": {
                                                        "OP": "ADD"
                                                      },
                                                      "id": "[TcsuycR6NC^aCgO$i]E",
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
                                                            "id": "$|N$$OkeJ5i9R?#bm[3C",
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
                                                            "id": "ExN.;n5Jf-d_4||!Z+S*",
                                                            "inputs": {
                                                              "A": {
                                                                "block": {
                                                                  "extraState": "<mutation></mutation>",
                                                                  "fields": {
                                                                    "TYPE": "board",
                                                                    "VAR": {
                                                                      "id": "jKYHQM:)v@h,zTna;:Zi"
                                                                    }
                                                                  },
                                                                  "id": "alsQQ~Ulk.kMWuy}1lO)",
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
                                                                  "id": "[@xNLDeOMX!#{iJP:8Jd",
                                                                  "inputs": {
                                                                    "A": {
                                                                      "block": {
                                                                        "fields": {
                                                                          "OP": "ADD"
                                                                        },
                                                                        "id": "%LZAE(}-T8~]@1:sP3wH",
                                                                        "inputs": {
                                                                          "A": {
                                                                            "block": {
                                                                              "fields": {
                                                                                "THIS": false,
                                                                                "VAR": "unitVariable:VelocityX"
                                                                              },
                                                                              "id": "g?cyes*VL|AlIzl3y*se",
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
                                                                              "id": "Qu_o9k*-6oZ#NN#j..:/",
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
                                                                        "id": "cSRGZnsIfOs#9p[uf.Rc",
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
                                                                      "id": "zP9v=6@H_Fow55U(;_=g"
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
                                                              "NUM": 525
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
                                                        "NUM": 330
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
                                                          "id": "zP9v=6@H_Fow55U(;_=g"
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
                                                  "NUM": 2400
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
                                                    "id": "zP9v=6@H_Fow55U(;_=g"
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
                                            "NUM": 330
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
                                  "id": "ENpDWX:ZVAIV[5K=f_2G",
                                  "inputs": {
                                    "DO0": {
                                      "block": {
                                        "id": "[O1eE|F.VVg+,=p8c9gv",
                                        "inputs": {
                                          "DO0": {
                                            "block": {
                                              "id": "r~^y^1DX|@fTJmhL/8ET",
                                              "inputs": {
                                                "DO0": {
                                                  "block": {
                                                    "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                    "fields": {
                                                      "NAME": "boardMethod:AddUnit",
                                                      "THIS": true
                                                    },
                                                    "id": "qoosuo9o@!,oLA6Bxc~K",
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
                                                          "id": "@Cp{=vE{|B*cWwwFj)^8",
                                                          "type": "variables_get"
                                                        }
                                                      },
                                                      "ARG2": {
                                                        "block": {
                                                          "fields": {
                                                            "OP": "ADD"
                                                          },
                                                          "id": "9kW`f1?NuU|EF@1PNe8M",
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
                                                                "id": "r[(24`n;qN*KEUV?rjpZ",
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
                                                                "id": "+:1eO)xfy6Q!w?wce#w`",
                                                                "inputs": {
                                                                  "A": {
                                                                    "block": {
                                                                      "extraState": "<mutation></mutation>",
                                                                      "fields": {
                                                                        "TYPE": "board",
                                                                        "VAR": {
                                                                          "id": "jKYHQM:)v@h,zTna;:Zi"
                                                                        }
                                                                      },
                                                                      "id": ";C:s%_AA:^oWN!Y1WY61",
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
                                                                      "id": "hdPkQHjJxQC?X;85tOWB",
                                                                      "inputs": {
                                                                        "A": {
                                                                          "block": {
                                                                            "fields": {
                                                                              "OP": "ADD"
                                                                            },
                                                                            "id": "Fa(w9SRu[8^H3wlIQ5lB",
                                                                            "inputs": {
                                                                              "A": {
                                                                                "block": {
                                                                                  "fields": {
                                                                                    "THIS": false,
                                                                                    "VAR": "unitVariable:VelocityX"
                                                                                  },
                                                                                  "id": "d#`u7NS3RCu,7:8pz|k?",
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
                                                                                  "id": "1?smdiZ@o)B{:_Kxxtae",
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
                                                                            "id": "ae8fBpo:5h2Nv-[.hr+K",
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
                                                          "id": "8Rs.FV2{1|!P.L2gpD9z",
                                                          "type": "math_number"
                                                        }
                                                      },
                                                      "ARG5": {
                                                        "block": {
                                                          "fields": {
                                                            "VAR": "Enemy"
                                                          },
                                                          "id": "$i|cuokKG_X5ACa^L=pL",
                                                          "type": "teamtag_get"
                                                        }
                                                      },
                                                      "ARG6": {
                                                        "block": {
                                                          "fields": {
                                                            "NUM": 1
                                                          },
                                                          "id": "HTewTu3$@UvK;Mbt8}2.",
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
                                                    "id": "Ug#bU2@6#g!Tx-.j|;Y1",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "id": "1m.O^I2~C|XYK)=dxQ/b",
                                                          "inputs": {
                                                            "DIVIDEND": {
                                                              "block": {
                                                                "fields": {
                                                                  "OP": "MINUS"
                                                                },
                                                                "id": "8D65:-3[ICOFK~,WS7PO",
                                                                "inputs": {
                                                                  "A": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "THIS": false,
                                                                        "VAR": "boardVariable:Tick"
                                                                      },
                                                                      "id": "DA62l.uG#.V+lr9^p,EB",
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
                                                                      "id": "-Uc|eNVpt|TxB;nz7E0*",
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
                                                                "id": "U#4qQ_KGwrlmYh/{L!8)",
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
                                                          "id": "uL@F-4(6.CN%_;XVHaV3",
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
                                              "id": "A[)oi_!^t-4Td.@{wPv/",
                                              "inputs": {
                                                "A": {
                                                  "block": {
                                                    "fields": {
                                                      "OP": "MINUS"
                                                    },
                                                    "id": "@NKOAO~(Ef7`cGUU+@FP",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "fields": {
                                                            "THIS": false,
                                                            "VAR": "boardVariable:Tick"
                                                          },
                                                          "id": "o~fp.Z6W-!y?vRW@:.b=",
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
                                                          "id": "Kl%$#3#iwyBbGu3wdK|W",
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
                                                    "id": "S[uLLI:djzU2ZhgH06k.",
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
                                        "id": "qbp0MzPiR@9:NtO-KMB@",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "OP": "MINUS"
                                              },
                                              "id": "#Y[0T$i1TJ^:f;/%WXlu",
                                              "inputs": {
                                                "A": {
                                                  "block": {
                                                    "fields": {
                                                      "THIS": false,
                                                      "VAR": "boardVariable:Tick"
                                                    },
                                                    "id": "H{w*PJNJs=5`$z%N:Qc4",
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
                                                    "id": "8I2#p;$zq#ZS*4V:I#b7",
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
                                              "id": "ZTP%8a*yKe(fA3k@zHt/",
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
                                      "id": "?}O+op1W#hSlJ$?rF)kP",
                                      "inputs": {
                                        "DO0": {
                                          "block": {
                                            "id": "{b^9/BKpB%9gQ]}UH#NE",
                                            "inputs": {
                                              "DO0": {
                                                "block": {
                                                  "id": "A`Zc2ukl{EEVXGrq?q;X",
                                                  "inputs": {
                                                    "DO0": {
                                                      "block": {
                                                        "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                        "fields": {
                                                          "NAME": "boardMethod:AddUnit",
                                                          "THIS": true
                                                        },
                                                        "id": "iZGwk:3CZM;5$..%VF[;",
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
                                                              "id": "CcyQyTnfS~maG7oX(5s[",
                                                              "type": "variables_get"
                                                            }
                                                          },
                                                          "ARG2": {
                                                            "block": {
                                                              "fields": {
                                                                "OP": "ADD"
                                                              },
                                                              "id": "nB*8*#WAJ%N#pN=,c`A]",
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
                                                                    "id": "%7PcvYga$[/Fg{9oAh6e",
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
                                                                    "id": "-1dCq6(2@gaP)-O=YC[N",
                                                                    "inputs": {
                                                                      "A": {
                                                                        "block": {
                                                                          "extraState": "<mutation></mutation>",
                                                                          "fields": {
                                                                            "TYPE": "board",
                                                                            "VAR": {
                                                                              "id": "jKYHQM:)v@h,zTna;:Zi"
                                                                            }
                                                                          },
                                                                          "id": "@B.yMnM0q!|WaVPvpwrt",
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
                                                                          "id": "TMY0rcPS+=$7{p4KW/1a",
                                                                          "inputs": {
                                                                            "A": {
                                                                              "block": {
                                                                                "fields": {
                                                                                  "OP": "ADD"
                                                                                },
                                                                                "id": "o[KSB^[8st|6s.Y;;kUY",
                                                                                "inputs": {
                                                                                  "A": {
                                                                                    "block": {
                                                                                      "fields": {
                                                                                        "THIS": false,
                                                                                        "VAR": "unitVariable:VelocityX"
                                                                                      },
                                                                                      "id": "2Fqa0BtOBOiQcf$oV(X(",
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
                                                                                      "id": "]MJ:MdkoxPWM;W5{`JMs",
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
                                                                                "id": "mjI/}B?LJv:iJY}8/ele",
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
                                                              "id": "Y93@{jO]_0m64,AeefNk",
                                                              "type": "math_number"
                                                            }
                                                          },
                                                          "ARG5": {
                                                            "block": {
                                                              "fields": {
                                                                "VAR": "Enemy"
                                                              },
                                                              "id": "(E|lUE7$jwk!/v0,r?yR",
                                                              "type": "teamtag_get"
                                                            }
                                                          },
                                                          "ARG6": {
                                                            "block": {
                                                              "fields": {
                                                                "NUM": 1
                                                              },
                                                              "id": "tY##![2?kf)s`$Lh+v;r",
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
                                                        "id": "I/0njEC-T[iu|12FFniX",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "id": "CO:IN;!UX?PY:N$^wQhI",
                                                              "inputs": {
                                                                "DIVIDEND": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "OP": "MINUS"
                                                                    },
                                                                    "id": "%P|}/D4l|*Kj(C{XKQAr",
                                                                    "inputs": {
                                                                      "A": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "THIS": false,
                                                                            "VAR": "boardVariable:Tick"
                                                                          },
                                                                          "id": "Qm^J~d=XkVM(;_+wZUUN",
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
                                                                          "id": "KD,e`R1/ZNG];zekVqoI",
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
                                                                      "NUM": 810
                                                                    },
                                                                    "id": "g]7iW-kHOeiLwP`z|%P5",
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
                                                                "NUM": 390
                                                              },
                                                              "id": "Iq9?X!H*v~hIqR@DsG4r",
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
                                                  "id": "=umFJ$S{%P1i6$D`diwE",
                                                  "inputs": {
                                                    "A": {
                                                      "block": {
                                                        "fields": {
                                                          "OP": "MINUS"
                                                        },
                                                        "id": "EXAqN`l9SN}6rOn({q@y",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "fields": {
                                                                "THIS": false,
                                                                "VAR": "boardVariable:Tick"
                                                              },
                                                              "id": "8FRb:~u*HLpWLRgAg0Z6",
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
                                                              "id": "?S9W}|9AV3yI,qS]ib9w",
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
                                                        "id": "iO#Y/]{4V}wPEPGVnNbs",
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
                                            "id": "){KuG+2Gqdf%rh9f3m3y",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "fields": {
                                                    "OP": "MINUS"
                                                  },
                                                  "id": "-`X5!5go*c|LyLFnEbXF",
                                                  "inputs": {
                                                    "A": {
                                                      "block": {
                                                        "fields": {
                                                          "THIS": false,
                                                          "VAR": "boardVariable:Tick"
                                                        },
                                                        "id": "a=rD]_lV]RQ,5A=KFwil",
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
                                                        "id": "kik0pre,F/H(}R3i87H0",
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
                                                    "NUM": 1200
                                                  },
                                                  "id": "AY9U8+5^1a,Vr-eh_7HZ",
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
                                          "id": "=4]k$}HIrx(tEbp:Ato!",
                                          "inputs": {
                                            "DO0": {
                                              "block": {
                                                "id": "O?2E`{Z1=b^*IH{[]RK!",
                                                "inputs": {
                                                  "DO0": {
                                                    "block": {
                                                      "id": "eM:/5bZqsAPjq?O^n}X6",
                                                      "inputs": {
                                                        "DO0": {
                                                          "block": {
                                                            "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                            "fields": {
                                                              "NAME": "boardMethod:AddUnit",
                                                              "THIS": true
                                                            },
                                                            "id": "EVY7eFK3=teROC(wy2Z8",
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
                                                                  "id": "*D~EKq!zSHX~]ltX%[Cj",
                                                                  "type": "variables_get"
                                                                }
                                                              },
                                                              "ARG2": {
                                                                "block": {
                                                                  "fields": {
                                                                    "OP": "ADD"
                                                                  },
                                                                  "id": "#rLLh~E`CQ|p_aIVlh6I",
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
                                                                        "id": "k;ED3@m~5D@`DNbHz2Cc",
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
                                                                        "id": "-%FQyVTuUJZmk/B.bqeM",
                                                                        "inputs": {
                                                                          "A": {
                                                                            "block": {
                                                                              "extraState": "<mutation></mutation>",
                                                                              "fields": {
                                                                                "TYPE": "board",
                                                                                "VAR": {
                                                                                  "id": "jKYHQM:)v@h,zTna;:Zi"
                                                                                }
                                                                              },
                                                                              "id": "`3r+(!f.s`~:%B_+ajW2",
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
                                                                              "id": ":P/1}+ae(i/kcW_FvVfH",
                                                                              "inputs": {
                                                                                "A": {
                                                                                  "block": {
                                                                                    "fields": {
                                                                                      "OP": "ADD"
                                                                                    },
                                                                                    "id": "nL;-Jt,|v8KNMISUbe,S",
                                                                                    "inputs": {
                                                                                      "A": {
                                                                                        "block": {
                                                                                          "fields": {
                                                                                            "THIS": false,
                                                                                            "VAR": "unitVariable:VelocityX"
                                                                                          },
                                                                                          "id": "gx1Fh7i:Tt`70I3@?8nf",
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
                                                                                          "id": ";d]ON/5FcujkVP-1,hLI",
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
                                                                                    "id": "Qdu/zzv.0?~=|-F3?}b`",
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
                                                                  "id": "v:co9~2dF$jb]Wy6uDZe",
                                                                  "type": "math_number"
                                                                }
                                                              },
                                                              "ARG5": {
                                                                "block": {
                                                                  "fields": {
                                                                    "VAR": "Enemy"
                                                                  },
                                                                  "id": "X`@FOdz/2iwlQw`L]Amd",
                                                                  "type": "teamtag_get"
                                                                }
                                                              },
                                                              "ARG6": {
                                                                "block": {
                                                                  "fields": {
                                                                    "NUM": 1
                                                                  },
                                                                  "id": "hq@7`tn,g5VeX7W+k,I2",
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
                                                            "id": ")nuIm;M20`yJvUD:Y(?6",
                                                            "inputs": {
                                                              "A": {
                                                                "block": {
                                                                  "id": "yye|cFw3nfELdP*X?nSW",
                                                                  "inputs": {
                                                                    "DIVIDEND": {
                                                                      "block": {
                                                                        "fields": {
                                                                          "OP": "MINUS"
                                                                        },
                                                                        "id": "GjR{dOb=(O]=B5SAX}d@",
                                                                        "inputs": {
                                                                          "A": {
                                                                            "block": {
                                                                              "fields": {
                                                                                "THIS": false,
                                                                                "VAR": "boardVariable:Tick"
                                                                              },
                                                                              "id": "zNLF*MTHT33I*w-u+`5:",
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
                                                                              "id": "*RLkY]JFF8Z6]rr9Vbhb",
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
                                                                          "NUM": 810
                                                                        },
                                                                        "id": "Ec8]cmO$FOA6}-giq|T[",
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
                                                                    "NUM": 405
                                                                  },
                                                                  "id": "m/lHt}MwL4jP68cF$`J:",
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
                                                      "id": "pA+L[rn*Snr9}]izn:y]",
                                                      "inputs": {
                                                        "A": {
                                                          "block": {
                                                            "fields": {
                                                              "OP": "MINUS"
                                                            },
                                                            "id": "NUPn~2)pEgr,]qY.f-7R",
                                                            "inputs": {
                                                              "A": {
                                                                "block": {
                                                                  "fields": {
                                                                    "THIS": false,
                                                                    "VAR": "boardVariable:Tick"
                                                                  },
                                                                  "id": "]Y.8.(V;}^Fmk9c5op@.",
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
                                                                  "id": "RcJc,S})c=A)t2.Qr9hX",
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
                                                            "id": "+g}k^{S/(AANYTcpz2_`",
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
                                                "id": "rOY^9:+8BU;+}5.dA;Nj",
                                                "inputs": {
                                                  "A": {
                                                    "block": {
                                                      "fields": {
                                                        "OP": "MINUS"
                                                      },
                                                      "id": "z1p^nuyM;.JY#kxmoF[0",
                                                      "inputs": {
                                                        "A": {
                                                          "block": {
                                                            "fields": {
                                                              "THIS": false,
                                                              "VAR": "boardVariable:Tick"
                                                            },
                                                            "id": "j=^Z%HxJti3cj8YUQIf=",
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
                                                            "id": "/dTdzBB7:ySX)XpE`a#_",
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
                                                        "NUM": 1215
                                                      },
                                                      "id": ":Dz+me=t!!$_$ab.,lf^",
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
                                              "id": "~ok$PJqkzTBR+Q(#ZwP5",
                                              "inputs": {
                                                "DO0": {
                                                  "block": {
                                                    "id": "Be*@cfP^F(qTW`P)uOoL",
                                                    "inputs": {
                                                      "DO0": {
                                                        "block": {
                                                          "id": "x1Ze?40r,g2sD^AJR#oW",
                                                          "inputs": {
                                                            "DO0": {
                                                              "block": {
                                                                "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                                "fields": {
                                                                  "NAME": "boardMethod:AddUnit",
                                                                  "THIS": true
                                                                },
                                                                "id": "HUmr_z`xFf1Zrdvb13NQ",
                                                                "inputs": {
                                                                  "ARG0": {
                                                                    "block": {
                                                                      "extraState": "<mutation></mutation>",
                                                                      "fields": {
                                                                        "TYPE": "board",
                                                                        "VAR": {
                                                                          "id": "l@8GcKz^P[Kk1%|M[DLk"
                                                                        }
                                                                      },
                                                                      "id": "1k@s@+hn_4,9}6PP}_)7",
                                                                      "type": "variables_get"
                                                                    }
                                                                  },
                                                                  "ARG2": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "OP": "ADD"
                                                                      },
                                                                      "id": "Pj~_CoSc}=NLzfMWf!sg",
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
                                                                            "id": "Ye%6chkWF0G{l|WN)cMl",
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
                                                                            "id": "@MglWwb@OV;#_`cjMHi^",
                                                                            "inputs": {
                                                                              "A": {
                                                                                "block": {
                                                                                  "extraState": "<mutation></mutation>",
                                                                                  "fields": {
                                                                                    "TYPE": "board",
                                                                                    "VAR": {
                                                                                      "id": "jKYHQM:)v@h,zTna;:Zi"
                                                                                    }
                                                                                  },
                                                                                  "id": "5sj:Yuf=Fh[CjmYh/_rS",
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
                                                                                  "id": "~XL]wWwAXv+!bT8@[B(n",
                                                                                  "inputs": {
                                                                                    "A": {
                                                                                      "block": {
                                                                                        "fields": {
                                                                                          "OP": "ADD"
                                                                                        },
                                                                                        "id": "QcYVh^m`Z7u9;`Vdu2EV",
                                                                                        "inputs": {
                                                                                          "A": {
                                                                                            "block": {
                                                                                              "fields": {
                                                                                                "THIS": false,
                                                                                                "VAR": "unitVariable:VelocityX"
                                                                                              },
                                                                                              "id": "u,zTo/Q06Zq;loSqc}v6",
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
                                                                                              "id": "!^+Sw7ZUR^5A)l%3@:uP",
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
                                                                                        "id": "B.@0qjIhf6Yh6[i.uww]",
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
                                                                      "id": "K;`95CpW1hrrv~78t,U9",
                                                                      "type": "math_number"
                                                                    }
                                                                  },
                                                                  "ARG5": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "VAR": "Enemy"
                                                                      },
                                                                      "id": "S.wb4$Vj494DuVy48r(2",
                                                                      "type": "teamtag_get"
                                                                    }
                                                                  },
                                                                  "ARG6": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "NUM": 1
                                                                      },
                                                                      "id": "jpjY3Hs%56kZwTQKtyyP",
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
                                                                "id": "M1KB|%k3LIbjgpT[l2DP",
                                                                "inputs": {
                                                                  "A": {
                                                                    "block": {
                                                                      "id": "@v070uxc66j;?ydDq;w;",
                                                                      "inputs": {
                                                                        "DIVIDEND": {
                                                                          "block": {
                                                                            "fields": {
                                                                              "OP": "MINUS"
                                                                            },
                                                                            "id": "#Y`oQlO+MTXmYnUf2Qa+",
                                                                            "inputs": {
                                                                              "A": {
                                                                                "block": {
                                                                                  "fields": {
                                                                                    "THIS": false,
                                                                                    "VAR": "boardVariable:Tick"
                                                                                  },
                                                                                  "id": "(w.DsCe6ysNq!V?uu;Y^",
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
                                                                                  "id": "*,m_fjPCsuY/-YGRkez/",
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
                                                                              "NUM": 810
                                                                            },
                                                                            "id": ".,Vgy6GHiKNayp(aV8ym",
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
                                                                      "id": "%*j-r(a,`zqU$SK`Jg7k",
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
                                                          "id": "]|!![|VReJk.Uf:5`czz",
                                                          "inputs": {
                                                            "A": {
                                                              "block": {
                                                                "fields": {
                                                                  "OP": "MINUS"
                                                                },
                                                                "id": "7W}Fgp|DV!yi@w$kzZ)*",
                                                                "inputs": {
                                                                  "A": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "THIS": false,
                                                                        "VAR": "boardVariable:Tick"
                                                                      },
                                                                      "id": "g~_zSzoI}nosjGYAR!dx",
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
                                                                      "id": "%mDPQM/t9Tl%w7^C|]Db",
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
                                                                "id": "N.U5UH*JTS[+imj;e;y+",
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
                                                    "id": "5iGv|tukFPSrv4T6sS;F",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "fields": {
                                                            "OP": "MINUS"
                                                          },
                                                          "id": "[E@AH-T3(`K=,xWki#S@",
                                                          "inputs": {
                                                            "A": {
                                                              "block": {
                                                                "fields": {
                                                                  "THIS": false,
                                                                  "VAR": "boardVariable:Tick"
                                                                },
                                                                "id": "y(G.(#{[];:5Ce!ZLa9P",
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
                                                                "id": "FG@5xs)gv!}F;$*eJKnR",
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
                                                            "NUM": 1230
                                                          },
                                                          "id": "jZEU=6dLl{MQ=XrF/]g:",
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
          "IF0": {
            "block": {
              "fields": {
                "OP": "AND"
              },
              "id": ":#[^oPrc(X+T4?{26N[K",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "GTE"
                    },
                    "id": "Q{ASdoZA/Kqw#8nBx!ff",
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
                          "id": "5Qy4)5JcgoA%]A5.IHj:",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "?J$3$7=M/.@Q2a*XYb={",
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
                    "id": "$J*/*uu^:X~l/D_dRJdv",
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
                          "id": "PL50uDX*8m8l0??:F;r;",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 3
                          },
                          "id": "EB3?-gVgb[jY94h`_=JJ",
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
        "y": -1885
      },
      {
        "id": "evP|hOTBM8C@ele]WeY#",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "TYPE": "board",
                "VAR": {
                  "id": "F//i`5m5GJ/iAUoeO`l["
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
                      "id": "/Jy:K_G7;g_[Z!4p5xKZ"
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
                      "id": "w{u}N*gvkJ=u4E;BhmM9",
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
                            "id": "#d1Ld%d4]FCJD]6@P:aZ",
                            "type": "variables_get"
                          }
                        },
                        "ARG1": {
                          "block": {
                            "fields": {
                              "NUM": 1
                            },
                            "id": "uA]vHCDLd?Ivm+);.#m7",
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
              "id": "*m%oo{(|p*VA-}A@NGf+",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "LTE"
                    },
                    "id": "c:!K[X][t$!BdR.c-sox",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "bHQ#P!U!uRZ_~~Ngr%%o",
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
                                "id": "[c2r27(Z35F`{O9+:.Ik",
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
                                "id": "PO(:m*{LCOwJ`gcuoFtS",
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
                          "id": "lto)w_mV4qLd}V9asX[)",
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
                    "id": "+Ub!lV_${WBw[p_NhYD2",
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
                          "id": "V.L4$7CplVd;d]|KBK?%",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 3
                          },
                          "id": ":kze6px=Upoc%@=LY/T0",
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
        "x": 575,
        "y": 2125
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
                        "id": "F//i`5m5GJ/iAUoeO`l["
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
                              "id": "F//i`5m5GJ/iAUoeO`l["
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
        "x": 635,
        "y": -2815
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Map_Default4_Wave3",
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
    },
    {
      "id": "C$j_x03=_ahz]#@F8HRc",
      "name": "Gem"
    },
    {
      "id": "NMJw)zN%kp%%^{}jNCuD",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "6h@1b(PI/xwghc`}+Ldl",
      "name": "Map/Player/Moving"
    },
    {
      "id": "V1]pj-/$G8ZunJ2,P8ms",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "4c!(wUXhC|D0fPru`;vg",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "45IBkE`,ut8vzSF3oL6{",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "M{_)J?hSf;1t@UhyfwM)",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "+):X!-,nBIuq,m45+[V_",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "Xt4b)=d$`,{a}}Lcp!md",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "D`$OYZHn,`=UAJbqqf=N",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "~|M)Ai;x6PsjOCdElcHP",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "K)e6z!uvX@5HW^Qs|B($",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "bQx,F(A+|WzhP15ws:R=",
      "name": "@Buff/Variable/10"
    },
    {
      "id": ";PJCmTZfYuUIdQy)o1vY",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "WIWIHWy_md[+n](G(T36",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "f)MfcufPTtd69D~bncL{",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "gwyQdV7MNuNe*!wgK^X7",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "Or-h{EK1PiM;bYDu}D}_",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "-o)z9)/$05Hk4ai;?t]T",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "~t~qR-OF4Y}q?WHOVeb$",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": ";Pl~}3xKwoFw@-Ns:7hj",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "nArLn^[_V~taJ:i[it.O",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "J,)+~CLt:(~AQa{UR*Ob",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "PwM%pUGBEhCj#TnRYG[N",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "vzN[gm%DA5lM*n_VfJ3G",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "D;g3+fB^IM*c`M^;L`3~",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": ")Uj8=GSeaW$$E:`p8u(A",
      "name": "@Map/Progress"
    },
    {
      "id": "+IvLX(7P75O?z~8JQ;k1",
      "name": "Map/DisplayWinningTeam"
    },
    {
      "id": "GEDRh4Zg:WW#rM1;;;Y[",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "WA]?h3_0BZxsks}L*1^i",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "7Y6c2}VJxJ!,twoBm@?-",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "_]9(TfrY92|mtEt!mrx9",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "2}t[s|kPBZ4,M5R$Pf3I",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "DsFq1LxZ9X]/9omxKpH.",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "K]|Ao0/,[84B`g2*d*2]",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "CKM`;*:E#;tOjpIRnlWF",
      "name": "🚨 Scout rewards maxed out!\nCollect Gold💰 & Gems💎, and power up!\nPlay Hamster Combat now! 👉 [Play Now]"
    },
    {
      "id": "l=|;Dq=}KvcF3S:$WK.;",
      "name": "@Map/WaveStartPlayerPosition"
    }
  ]
}