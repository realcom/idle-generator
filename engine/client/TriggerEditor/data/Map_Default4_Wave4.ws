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
                      "NUM": 4
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
        "x": 115,
        "y": -625
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
                      "TEXT": "Default4_Battle_04_01"
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
                  "id": "Fh*@2Eb,(7%qV2](7B0R",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "fields": {
                          "NUM": 2
                        },
                        "id": ",,rnnW0}H$TKP]ZI0=b9",
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
                                        "NUM": 3000
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
                                  "next": {
                                    "block": {
                                      "fields": {
                                        "TYPE": "board",
                                        "VAR": {
                                          "id": "o,xKeQe}t5}Q]cui@aQG"
                                        }
                                      },
                                      "id": "l!2?,V)5[4cW2`2Ck`^#",
                                      "inputs": {
                                        "VALUE": {
                                          "block": {
                                            "fields": {
                                              "BOOL": "TRUE"
                                            },
                                            "id": "Lf.Wg;vXd^r*4JIJI(5Y",
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
        "type": "controls_if",
        "x": 75,
        "y": -455
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
                          "NUM": 2
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
                          "id": ":exT)%gVFw,=tcjABwlL"
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
                              "id": "g0,Syv!5uD33Vx2Ec;Qp"
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
                        "id": "B{=KU.#xP0RT78}|Gjr;",
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
                              "id": ":exT)%gVFw,=tcjABwlL"
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
                                      "id": ":exT)%gVFw,=tcjABwlL"
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
        "x": 65,
        "y": 505
      },
      {
        "id": "KApa6!v@ca#G0c;(`jgm",
        "inputs": {
          "DO0": {
            "block": {
              "id": "Y}wqv}4a0{?O0pBoqh9F",
              "inputs": {
                "DO0": {
                  "block": {
                    "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                    "fields": {
                      "NAME": "boardMethod:ShowPopup",
                      "THIS": false
                    },
                    "id": ")n07vx=K]Z6wGi-15^Dc",
                    "inputs": {
                      "TEXT": {
                        "block": {
                          "fields": {
                            "TEXT": "Popup_BigWaveAlert"
                          },
                          "id": "L(z2c*XUGwkHaZv[S{ND",
                          "type": "text"
                        }
                      },
                      "VAR1": {
                        "block": {
                          "fields": {
                            "NUM": 0
                          },
                          "id": "Dty?S*62#h;nSs%uPCzQ",
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
                    "id": "_*Ok;cRm,)/bJJVHt[k4",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "=HpFv{-Mp8g/QR;681=L",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "THIS": false,
                                  "VAR": "boardVariable:Tick"
                                },
                                "id": "A#]R{^%:,PuGVi5~1Qqq",
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
                                "id": "pl`eTr5nl4k:[3/U4{3P",
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
                            "NUM": 1575
                          },
                          "id": "|u_J*Gxf[]f[MzR!,~/z",
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
                  "id": "RWkG5V?#~liDL5Czxt2`",
                  "inputs": {
                    "DO0": {
                      "block": {
                        "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                        "fields": {
                          "NAME": "boardMethod:ShowPopup",
                          "THIS": false
                        },
                        "id": "P.dnPWF|k,+Ap?i]I#D4",
                        "inputs": {
                          "TEXT": {
                            "block": {
                              "fields": {
                                "TEXT": "Popup_BigWaveAlert"
                              },
                              "id": "]=#1::$2LXnz=h2?wsp`",
                              "type": "text"
                            }
                          },
                          "VAR1": {
                            "block": {
                              "fields": {
                                "NUM": 0
                              },
                              "id": "Ow}IEzy6cKEnB!fnvUUz",
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
                        "id": "h:-Tp/PVJ^%cedG%m!qt",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "OP": "MINUS"
                              },
                              "id": "u!nuWfqDhDanLen{I3${",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "THIS": false,
                                      "VAR": "boardVariable:Tick"
                                    },
                                    "id": "ivN$X}dN?(NPY{k}G.pr",
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
                                    "id": "4%.01EFp%kA2w!]JH5#:",
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
                                "NUM": 2475
                              },
                              "id": "]s7]bBZZ(drPd/TX{u66",
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
                                                  "id": "}3b@9:h(9N55Ki8wWU{Y"
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
                                                              "id": ")ou4waRr]e99J*/yf?vq"
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
                                          "NUM": 3000
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
                                                      "id": "rnZp:2A5L.{aATm/`T6w"
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
                                                  "id": "giNv[CyVb0@o:,TSg}i[",
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
                                                        "id": ")WU`bvtz^@Av@!;*Qc)y",
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
                                                        "id": "5KvP}CRSx#|2;|hBkX:8",
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
                                                              "id": "S{ICYx0*DF]YedLpQiw7",
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
                                                              "id": "pbWO[`)n-[~@WW/hIQyW",
                                                              "inputs": {
                                                                "A": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "OP": "ADD"
                                                                    },
                                                                    "id": "!;p4T-qxuS]l.*0QLY_=",
                                                                    "inputs": {
                                                                      "A": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "THIS": false,
                                                                            "VAR": "unitVariable:VelocityX"
                                                                          },
                                                                          "id": "i~x6#D#(TO3PExvYucq,",
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
                                                                          "id": "Meb1HhL]}sC8pO6IXkdn",
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
                                                                    "id": "z9!!oI1xf4AI{0~rX|OB",
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
                                              "NUM": 3000
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
                                                          "id": "yc=:WXh*E?F4dwOv;C25"
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
                                                      "id": "/XbzenIP^@%:]v(4T8ej",
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
                                                            "id": "_JU_Njb9I]g1;Bgc=:oG",
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
                                                            "id": "H;hor)mW7crSviXCB}K5",
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
                                                                  "id": "!^l(vU|Kw+D-eGce]M4(",
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
                                                                  "id": "Y+O_@x{9kqfY:Yy^U):K",
                                                                  "inputs": {
                                                                    "A": {
                                                                      "block": {
                                                                        "fields": {
                                                                          "OP": "ADD"
                                                                        },
                                                                        "id": "=p~xa/SX9.r{F+xy4iXE",
                                                                        "inputs": {
                                                                          "A": {
                                                                            "block": {
                                                                              "fields": {
                                                                                "THIS": false,
                                                                                "VAR": "unitVariable:VelocityX"
                                                                              },
                                                                              "id": "ZrBkT%xt@|(gK[YHWyDx",
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
                                                                              "id": "JS+L_ItWgv%z4w4Iau[v",
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
                                                                        "id": "v5;XuUX{P5hZ:T/=T?I7",
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
                                                                      "id": "ec;fD/S5v@$zI1xMqqt`"
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
                                                              "NUM": 420
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
                                                        "NUM": 120
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
                                                          "id": "ec;fD/S5v@$zI1xMqqt`"
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
                                                  "NUM": 3000
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
                                                    "id": "ec;fD/S5v@$zI1xMqqt`"
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
                                            "NUM": 120
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
                                  "id": "Q!aSdSOv$3-ucX=pZzy^",
                                  "inputs": {
                                    "DO0": {
                                      "block": {
                                        "id": "^|sT8#971BZ0h|b;w/dI",
                                        "inputs": {
                                          "DO0": {
                                            "block": {
                                              "id": "2a2Jbq?h(`Qd^$i@5S_c",
                                              "inputs": {
                                                "DO0": {
                                                  "block": {
                                                    "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                    "fields": {
                                                      "NAME": "boardMethod:AddUnit",
                                                      "THIS": true
                                                    },
                                                    "id": "(iW?FZdgKtkBfixrS%Si",
                                                    "inputs": {
                                                      "ARG0": {
                                                        "block": {
                                                          "extraState": "<mutation></mutation>",
                                                          "fields": {
                                                            "TYPE": "board",
                                                            "VAR": {
                                                              "id": "kmB$HhJhsjy+7$`x|CNg"
                                                            }
                                                          },
                                                          "id": ".INO,*%:))yMJYb$vZ.:",
                                                          "type": "variables_get"
                                                        }
                                                      },
                                                      "ARG2": {
                                                        "block": {
                                                          "fields": {
                                                            "OP": "ADD"
                                                          },
                                                          "id": "6~LO[[)tqW0DL/hFxeQg",
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
                                                                "id": "2~|`dCNx-,]KG/U_DsQ3",
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
                                                                "id": "Y[v[,lFFsK!TjA9P_q*I",
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
                                                                      "id": "s))Pb?_Xq5]*{Th4i$7u",
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
                                                                      "id": "LG1Og{HS*GT{@$+e*qw:",
                                                                      "inputs": {
                                                                        "A": {
                                                                          "block": {
                                                                            "fields": {
                                                                              "OP": "ADD"
                                                                            },
                                                                            "id": "=Ltr8:;ghn(ZceuW^r+*",
                                                                            "inputs": {
                                                                              "A": {
                                                                                "block": {
                                                                                  "fields": {
                                                                                    "THIS": false,
                                                                                    "VAR": "unitVariable:VelocityX"
                                                                                  },
                                                                                  "id": "C?,*ZuoC==c9MTa1|}JW",
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
                                                                                  "id": "!_SmYWWCK{p@PsFcl$.j",
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
                                                                            "id": "Fb158ISQdd0fTa%8iBb#",
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
                                                          "id": "hDj,L/u-!!!Kq*CB~rtL",
                                                          "type": "math_number"
                                                        }
                                                      },
                                                      "ARG5": {
                                                        "block": {
                                                          "fields": {
                                                            "VAR": "Enemy"
                                                          },
                                                          "id": "G/c}~%tRf$4uu{)PU2x`",
                                                          "type": "teamtag_get"
                                                        }
                                                      },
                                                      "ARG6": {
                                                        "block": {
                                                          "fields": {
                                                            "NUM": 1
                                                          },
                                                          "id": "~tWs-%tOs7$j%D-.J?dt",
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
                                                    "id": "Ih#(4Xf9A*!bV|%L;(ZX",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "id": "u{8pax}IZftQG0=]ATTV",
                                                          "inputs": {
                                                            "DIVIDEND": {
                                                              "block": {
                                                                "fields": {
                                                                  "OP": "MINUS"
                                                                },
                                                                "id": "f@7H%oZM)}hMVu^a!];8",
                                                                "inputs": {
                                                                  "A": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "THIS": false,
                                                                        "VAR": "boardVariable:Tick"
                                                                      },
                                                                      "id": "1$LOBOe!-;HK/q7PBJ4I",
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
                                                                      "id": "JVcfh61?R:@!WeG7e@Ml",
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
                                                                "id": "L3:lGD;S(t[VnEX9X7wx",
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
                                                          "id": "m;|wTx@m2lC^UetP$TDx",
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
                                              "id": "zV{q]Z=HTRR#-5{=ys=a",
                                              "inputs": {
                                                "A": {
                                                  "block": {
                                                    "fields": {
                                                      "OP": "MINUS"
                                                    },
                                                    "id": "8[PADHy5mr1Hn#4NjOOq",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "fields": {
                                                            "THIS": false,
                                                            "VAR": "boardVariable:Tick"
                                                          },
                                                          "id": "NJ$]TxS{pfj[Pj#uesJ(",
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
                                                          "id": "tLyg_-KC,.}!!hC_SA[8",
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
                                                      "NUM": 3000
                                                    },
                                                    "id": "g9kU@h7![0dkK{:SqSWq",
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
                                        "id": "ZX,3hw=$J|OF;GY+$~s9",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "OP": "MINUS"
                                              },
                                              "id": "Y4JJdhv0W^*u[kkHZ3V8",
                                              "inputs": {
                                                "A": {
                                                  "block": {
                                                    "fields": {
                                                      "THIS": false,
                                                      "VAR": "boardVariable:Tick"
                                                    },
                                                    "id": "]C[5)d}`1Om~Ih~4nz[4",
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
                                                    "id": "0Ea|}FB$pAJ;4:903jT;",
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
                                              "id": "7KOBT[2aU=Ljda`5Aa6d",
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
                                      "id": "QVJ4bM/MC%S/$%HP($Q]",
                                      "inputs": {
                                        "DO0": {
                                          "block": {
                                            "id": ":?oM1-r:]TL(FeuV?gTW",
                                            "inputs": {
                                              "DO0": {
                                                "block": {
                                                  "id": "B=r.P!$pDp1x?k*#!iV+",
                                                  "inputs": {
                                                    "DO0": {
                                                      "block": {
                                                        "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                        "fields": {
                                                          "NAME": "boardMethod:AddUnit",
                                                          "THIS": true
                                                        },
                                                        "id": "e^|kkacH}f8m[QP.c;D(",
                                                        "inputs": {
                                                          "ARG0": {
                                                            "block": {
                                                              "extraState": "<mutation></mutation>",
                                                              "fields": {
                                                                "TYPE": "board",
                                                                "VAR": {
                                                                  "id": "yc=:WXh*E?F4dwOv;C25"
                                                                }
                                                              },
                                                              "id": "O`%6i{N8FO*]$^F{_awf",
                                                              "type": "variables_get"
                                                            }
                                                          },
                                                          "ARG2": {
                                                            "block": {
                                                              "fields": {
                                                                "OP": "ADD"
                                                              },
                                                              "id": "^xosLQC{B}Z(`Cm=THDY",
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
                                                                    "id": "%WI=^Iw(fk;ffH~0Y~G%",
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
                                                                    "id": "WW7emlg?xKy$Y.y][H7!",
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
                                                                          "id": ";v;mftYRPdZ!m0Fhl.dJ",
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
                                                                          "id": "s}kMxu:}cZVZi=u=pl%8",
                                                                          "inputs": {
                                                                            "A": {
                                                                              "block": {
                                                                                "fields": {
                                                                                  "OP": "ADD"
                                                                                },
                                                                                "id": ";1$$^3nA1`BNBmWSP9bJ",
                                                                                "inputs": {
                                                                                  "A": {
                                                                                    "block": {
                                                                                      "fields": {
                                                                                        "THIS": false,
                                                                                        "VAR": "unitVariable:VelocityX"
                                                                                      },
                                                                                      "id": "kAyrq4gSoxxDGYB;SR9N",
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
                                                                                      "id": "4|o+(1FFt{H4_rWsI{6:",
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
                                                                                "id": "0H)+xv;~$FFT9hv0R3(8",
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
                                                              "id": "fS-LIgSaG~bdrAuA*]NI",
                                                              "type": "math_number"
                                                            }
                                                          },
                                                          "ARG5": {
                                                            "block": {
                                                              "fields": {
                                                                "VAR": "Enemy"
                                                              },
                                                              "id": "Y2uhf99$T}khkhN@c8|2",
                                                              "type": "teamtag_get"
                                                            }
                                                          },
                                                          "ARG6": {
                                                            "block": {
                                                              "fields": {
                                                                "NUM": 1
                                                              },
                                                              "id": "LEvu.PU5[V{{hF/zP/qN",
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
                                                        "id": "}pN0HMVgj3;xO;i[(50u",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "id": "vegm^,wkN1a:av1h%eSq",
                                                              "inputs": {
                                                                "DIVIDEND": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "OP": "MINUS"
                                                                    },
                                                                    "id": "F$Frc_6^1Mo%#88A=-Md",
                                                                    "inputs": {
                                                                      "A": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "THIS": false,
                                                                            "VAR": "boardVariable:Tick"
                                                                          },
                                                                          "id": "~PtvY:8n)_P+Tzdao++2",
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
                                                                          "id": "0+rNn=}aWZS/c#W4VHrd",
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
                                                                    "id": "G/o7E|v8hevZ?V3Jyejg",
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
                                                              "id": "0Tm$Oa8q=-}OlDTil;D-",
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
                                                  "id": "(qgKJ)yr27``R|g7$Zx-",
                                                  "inputs": {
                                                    "A": {
                                                      "block": {
                                                        "fields": {
                                                          "OP": "MINUS"
                                                        },
                                                        "id": "JsA*0qU:GY(An0PugD8}",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "fields": {
                                                                "THIS": false,
                                                                "VAR": "boardVariable:Tick"
                                                              },
                                                              "id": "ND9NO8`{@F$)|5j62wXs",
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
                                                              "id": "myGspm:Zs^,wr*mY,nVD",
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
                                                          "NUM": 3000
                                                        },
                                                        "id": "+.0RQv#!b8R4!*4Q5EY%",
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
                                            "id": "g=%UA.AD!$Z9Hf6RqY+U",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "fields": {
                                                    "OP": "MINUS"
                                                  },
                                                  "id": "uNo60Fw#gNve3e/kz]Q$",
                                                  "inputs": {
                                                    "A": {
                                                      "block": {
                                                        "fields": {
                                                          "THIS": false,
                                                          "VAR": "boardVariable:Tick"
                                                        },
                                                        "id": "3(*H3B,wRjrN73P/d.$[",
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
                                                        "id": "DE(gXSAmoMC3fE!]n4$p",
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
                                                  "id": "}Jxh`~i:qnrux6H[X%,9",
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
                                          "id": "2cvglWRB^KWp[#1NSX6#",
                                          "inputs": {
                                            "DO0": {
                                              "block": {
                                                "id": "Y:;7DR__;M[),q#L6G8G",
                                                "inputs": {
                                                  "DO0": {
                                                    "block": {
                                                      "id": "Dju/0qfiCP9:%CF^hrUD",
                                                      "inputs": {
                                                        "DO0": {
                                                          "block": {
                                                            "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                            "fields": {
                                                              "NAME": "boardMethod:AddUnit",
                                                              "THIS": true
                                                            },
                                                            "id": "Dd+.rD.-aT*K?9f|2A$l",
                                                            "inputs": {
                                                              "ARG0": {
                                                                "block": {
                                                                  "extraState": "<mutation></mutation>",
                                                                  "fields": {
                                                                    "TYPE": "board",
                                                                    "VAR": {
                                                                      "id": "kmB$HhJhsjy+7$`x|CNg"
                                                                    }
                                                                  },
                                                                  "id": "kq_]F=xHYuhv/M[]XY=E",
                                                                  "type": "variables_get"
                                                                }
                                                              },
                                                              "ARG2": {
                                                                "block": {
                                                                  "fields": {
                                                                    "OP": "ADD"
                                                                  },
                                                                  "id": "d{]:~)KXueWT*l1XtwJq",
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
                                                                        "id": "=_=q}#/P_QwhR5-J/4Y`",
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
                                                                        "id": "I1TQ7{s4a-vB7/Mmc`o8",
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
                                                                              "id": "osdgN*]a6/4Z{?o]`Kg-",
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
                                                                              "id": "5AkG~@qR:Z*0t3ldjXjO",
                                                                              "inputs": {
                                                                                "A": {
                                                                                  "block": {
                                                                                    "fields": {
                                                                                      "OP": "ADD"
                                                                                    },
                                                                                    "id": "Cs-iTFsC~}4}E*J3tZGB",
                                                                                    "inputs": {
                                                                                      "A": {
                                                                                        "block": {
                                                                                          "fields": {
                                                                                            "THIS": false,
                                                                                            "VAR": "unitVariable:VelocityX"
                                                                                          },
                                                                                          "id": "s#:Ft0Je}$cMwYz^4*4S",
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
                                                                                          "id": "iw0oADA`LP/bz2t/{]Y0",
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
                                                                                    "id": "Cj4b{}_Gurm36^?~|*?o",
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
                                                                  "id": "M:LU$93-x,45YX}sqMFE",
                                                                  "type": "math_number"
                                                                }
                                                              },
                                                              "ARG5": {
                                                                "block": {
                                                                  "fields": {
                                                                    "VAR": "Enemy"
                                                                  },
                                                                  "id": "TyYaL3T$`8Nsl9zRs3_K",
                                                                  "type": "teamtag_get"
                                                                }
                                                              },
                                                              "ARG6": {
                                                                "block": {
                                                                  "fields": {
                                                                    "NUM": 1
                                                                  },
                                                                  "id": "r!p0mM)Cp~[8jAeu.em1",
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
                                                            "id": "?@zhCzF63ntVU7-zdwv/",
                                                            "inputs": {
                                                              "A": {
                                                                "block": {
                                                                  "id": "KjVmDW8`@m%/}7:!HL#]",
                                                                  "inputs": {
                                                                    "DIVIDEND": {
                                                                      "block": {
                                                                        "fields": {
                                                                          "OP": "MINUS"
                                                                        },
                                                                        "id": "+_R0}oSx*xfbe+v*FACy",
                                                                        "inputs": {
                                                                          "A": {
                                                                            "block": {
                                                                              "fields": {
                                                                                "THIS": false,
                                                                                "VAR": "boardVariable:Tick"
                                                                              },
                                                                              "id": "]GEx+q%S*XS-be!yX#|V",
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
                                                                              "id": "8oZz+eq2Z`}^J.6mwr?b",
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
                                                                        "id": "t=LaBK1Y+Y*uyZ8FNI*(",
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
                                                                  "id": "8Fxpiq?nfY,t/MpbTBML",
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
                                                      "id": "SaR96z{[mw*+1Cn|(+Jq",
                                                      "inputs": {
                                                        "A": {
                                                          "block": {
                                                            "fields": {
                                                              "OP": "MINUS"
                                                            },
                                                            "id": ";-HX}@;k;L1~qeQ,hOqQ",
                                                            "inputs": {
                                                              "A": {
                                                                "block": {
                                                                  "fields": {
                                                                    "THIS": false,
                                                                    "VAR": "boardVariable:Tick"
                                                                  },
                                                                  "id": "4A4,bKcOK*H:jC*L/Wjb",
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
                                                                  "id": "I:[xjz`(^b~^]yWqOBw|",
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
                                                              "NUM": 3000
                                                            },
                                                            "id": "PS]2N!kIkBsjMWaF9NFH",
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
                                                "id": "Jbq@U:tzP0cCbNKoJ8]T",
                                                "inputs": {
                                                  "A": {
                                                    "block": {
                                                      "fields": {
                                                        "OP": "MINUS"
                                                      },
                                                      "id": "[@v]C_?F*Y+);fLW6;Sc",
                                                      "inputs": {
                                                        "A": {
                                                          "block": {
                                                            "fields": {
                                                              "THIS": false,
                                                              "VAR": "boardVariable:Tick"
                                                            },
                                                            "id": "1)vhV3)`0JX_:MsxGU$E",
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
                                                            "id": "%uNioL.BRr^7R8[?L+{:",
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
                                                      "id": "G@QaAvJVd0sM|/BKAJF)",
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
                                              "id": "GA$dLzn7nmOk{d.@|`}C",
                                              "inputs": {
                                                "DO0": {
                                                  "block": {
                                                    "id": "f?o8qxmLp=}K0A+jHNj9",
                                                    "inputs": {
                                                      "DO0": {
                                                        "block": {
                                                          "id": "4B:`:,$*%wP5imrapdRL",
                                                          "inputs": {
                                                            "DO0": {
                                                              "block": {
                                                                "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                                "fields": {
                                                                  "NAME": "boardMethod:AddUnit",
                                                                  "THIS": true
                                                                },
                                                                "id": "dP:`Yc--RskqjqLggW47",
                                                                "inputs": {
                                                                  "ARG0": {
                                                                    "block": {
                                                                      "extraState": "<mutation></mutation>",
                                                                      "fields": {
                                                                        "TYPE": "board",
                                                                        "VAR": {
                                                                          "id": "yc=:WXh*E?F4dwOv;C25"
                                                                        }
                                                                      },
                                                                      "id": ")M/_tC5hn_Y6f*Z:Q^D8",
                                                                      "type": "variables_get"
                                                                    }
                                                                  },
                                                                  "ARG2": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "OP": "ADD"
                                                                      },
                                                                      "id": "nqY0qhlzlxsUed.G%Ph)",
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
                                                                            "id": "$b$]Fc8Ma)cZm{zc)#r@",
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
                                                                            "id": "2/@:M?Q9v[Lt^X-J~l4I",
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
                                                                                  "id": "BZ8Al_8T]kMhczt^m#~H",
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
                                                                                  "id": "%m/cXC:bxsrShJnBA$8Y",
                                                                                  "inputs": {
                                                                                    "A": {
                                                                                      "block": {
                                                                                        "fields": {
                                                                                          "OP": "ADD"
                                                                                        },
                                                                                        "id": "y/V-Q%m5GR;n$tFBQ3[t",
                                                                                        "inputs": {
                                                                                          "A": {
                                                                                            "block": {
                                                                                              "fields": {
                                                                                                "THIS": false,
                                                                                                "VAR": "unitVariable:VelocityX"
                                                                                              },
                                                                                              "id": "hn@f(YYe!NiG#E-F2@SI",
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
                                                                                              "id": "iZG9]{*dRzx/e|3Xux+9",
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
                                                                                        "id": "1s)/*afGRR6C1x0XA4Id",
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
                                                                      "id": "~B9h(6N93x9gIG`qLA%B",
                                                                      "type": "math_number"
                                                                    }
                                                                  },
                                                                  "ARG5": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "VAR": "Enemy"
                                                                      },
                                                                      "id": "ttMo*Z%gU!EUF4DO+:W*",
                                                                      "type": "teamtag_get"
                                                                    }
                                                                  },
                                                                  "ARG6": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "NUM": 1
                                                                      },
                                                                      "id": "8L/E1=Gsw(A!X|tZ@qBd",
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
                                                                "id": "iKM(-,W^UmB8Ia5Vu*;C",
                                                                "inputs": {
                                                                  "A": {
                                                                    "block": {
                                                                      "id": "f6HwycI?|`!vK^dW*h`^",
                                                                      "inputs": {
                                                                        "DIVIDEND": {
                                                                          "block": {
                                                                            "fields": {
                                                                              "OP": "MINUS"
                                                                            },
                                                                            "id": "1V0k{ND:K!`23FL7ICx.",
                                                                            "inputs": {
                                                                              "A": {
                                                                                "block": {
                                                                                  "fields": {
                                                                                    "THIS": false,
                                                                                    "VAR": "boardVariable:Tick"
                                                                                  },
                                                                                  "id": "[*hmje)9xvGeE);10qA7",
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
                                                                                  "id": "ND/-Z=gMg}_n.rNLD(%-",
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
                                                                            "id": "p,H:h)5*ol.``gTpiycG",
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
                                                                      "id": ")C73-w9~Jow)Yb.*X_}e",
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
                                                          "id": "`ExO$]E4[%^toUT4kS$}",
                                                          "inputs": {
                                                            "A": {
                                                              "block": {
                                                                "fields": {
                                                                  "OP": "MINUS"
                                                                },
                                                                "id": "j3Zdj_r`CudkUaA+UIRv",
                                                                "inputs": {
                                                                  "A": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "THIS": false,
                                                                        "VAR": "boardVariable:Tick"
                                                                      },
                                                                      "id": "-:g:oy22rjD@r9lKn*EP",
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
                                                                      "id": "//qy(2S)_9acQ=Dln`(k",
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
                                                                  "NUM": 3000
                                                                },
                                                                "id": "r|7EJXrsvW9wG(~AqA+k",
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
                                                    "id": "8jn0),oQ-DbF]_QpGZ-N",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "fields": {
                                                            "OP": "MINUS"
                                                          },
                                                          "id": "_[xfCHIQjdB53yUYKV)-",
                                                          "inputs": {
                                                            "A": {
                                                              "block": {
                                                                "fields": {
                                                                  "THIS": false,
                                                                  "VAR": "boardVariable:Tick"
                                                                },
                                                                "id": "}S#iy{DQW1K_wwHr~:[D",
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
                                                                "id": "mO[:ho;JU%_^j)WXiB{X",
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
                                                          "id": "8w!kIYe-?uf.L_%.ZqRj",
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
                                                  "id": "3ou:`T,g$~YOQO.Pr-ZY",
                                                  "inputs": {
                                                    "DO0": {
                                                      "block": {
                                                        "id": "d?!7{l[UR1pOZw$K#h+f",
                                                        "inputs": {
                                                          "DO0": {
                                                            "block": {
                                                              "id": "EqIDWdEe%v6:DzJhK;@f",
                                                              "inputs": {
                                                                "DO0": {
                                                                  "block": {
                                                                    "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                                    "fields": {
                                                                      "NAME": "boardMethod:AddUnit",
                                                                      "THIS": true
                                                                    },
                                                                    "id": "2IYM$;@L(6SXmGYDX#}8",
                                                                    "inputs": {
                                                                      "ARG0": {
                                                                        "block": {
                                                                          "extraState": "<mutation></mutation>",
                                                                          "fields": {
                                                                            "TYPE": "board",
                                                                            "VAR": {
                                                                              "id": "~SLf4_Tarw~1NWSrv*-G"
                                                                            }
                                                                          },
                                                                          "id": "5X{Oooq8p(p(tN^.6dL9",
                                                                          "type": "variables_get"
                                                                        }
                                                                      },
                                                                      "ARG2": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "OP": "ADD"
                                                                          },
                                                                          "id": "VgU,8R!bFSQXUZ6`9SsD",
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
                                                                                "id": "xs~|UA0L#bc=0!J|c@=J",
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
                                                                                "id": "@n^F(S3biN^[+T/oVH~V",
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
                                                                                      "id": "216rU%]L)C#pjNnLaZ+t",
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
                                                                                      "id": ":!K{Rfm%ue`TySl~uh!E",
                                                                                      "inputs": {
                                                                                        "A": {
                                                                                          "block": {
                                                                                            "fields": {
                                                                                              "OP": "ADD"
                                                                                            },
                                                                                            "id": "u;0fF6]:UgC1}WRohz/g",
                                                                                            "inputs": {
                                                                                              "A": {
                                                                                                "block": {
                                                                                                  "fields": {
                                                                                                    "THIS": false,
                                                                                                    "VAR": "unitVariable:VelocityX"
                                                                                                  },
                                                                                                  "id": "|k)+,].%2`yNNQo]_5.-",
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
                                                                                                  "id": "Q(%#b@1MJ#`,zj@Egim@",
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
                                                                                            "id": "@z7{r?n,3f[a?tqPd3)x",
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
                                                                          "id": "bcb]dz94?)R[?hoU4,JL",
                                                                          "type": "math_number"
                                                                        }
                                                                      },
                                                                      "ARG5": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "VAR": "Enemy"
                                                                          },
                                                                          "id": "j}giLkE;Sv7HH=Y4gPgq",
                                                                          "type": "teamtag_get"
                                                                        }
                                                                      },
                                                                      "ARG6": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "NUM": 1
                                                                          },
                                                                          "id": "V2OOf},z%Pl,PZv39ej1",
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
                                                                    "id": "!xx%,S*#.:$s]l7`q~.|",
                                                                    "inputs": {
                                                                      "A": {
                                                                        "block": {
                                                                          "id": "r;Bag9~P_$F`|TYirN:u",
                                                                          "inputs": {
                                                                            "DIVIDEND": {
                                                                              "block": {
                                                                                "fields": {
                                                                                  "OP": "MINUS"
                                                                                },
                                                                                "id": "meH%,Z5qweu#HMTRaDEI",
                                                                                "inputs": {
                                                                                  "A": {
                                                                                    "block": {
                                                                                      "fields": {
                                                                                        "THIS": false,
                                                                                        "VAR": "boardVariable:Tick"
                                                                                      },
                                                                                      "id": "v/VB?V/h=:*P(,vKqP]z",
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
                                                                                      "id": "h{ny.f{X.KSf/G{6Sy`;",
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
                                                                                "id": "V%mi/E]Qn6ihVTg)z}9e",
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
                                                                            "NUM": 675
                                                                          },
                                                                          "id": "+Dj4^7L6$)mpR*#{-s+x",
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
                                                              "id": "~]D/jmbi~_E;5KBT=~XK",
                                                              "inputs": {
                                                                "A": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "OP": "MINUS"
                                                                    },
                                                                    "id": "teh8-}^RD^*8!Jqq7Z_w",
                                                                    "inputs": {
                                                                      "A": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "THIS": false,
                                                                            "VAR": "boardVariable:Tick"
                                                                          },
                                                                          "id": "h+6vp22?Yluv6UQiU7(S",
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
                                                                          "id": ".J9ljO]Kt43.u%gAgq)9",
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
                                                                      "NUM": 3000
                                                                    },
                                                                    "id": "`zntqw,7#_D-R+L}(jD`",
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
                                                        "id": "8XN7MFb3jjjW`d~*BtUE",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "fields": {
                                                                "OP": "MINUS"
                                                              },
                                                              "id": "i5k?Zwam%R8k0B0jXEBI",
                                                              "inputs": {
                                                                "A": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "THIS": false,
                                                                      "VAR": "boardVariable:Tick"
                                                                    },
                                                                    "id": "Y7vDoOtGMA#6{Lm98C!5",
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
                                                                    "id": "e0waF%Rh`30E9xN6Hc2H",
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
                                                                "NUM": 1575
                                                              },
                                                              "id": "6=o,O_I]icU3lTlu=I*_",
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
          "IF0": {
            "block": {
              "fields": {
                "OP": "AND"
              },
              "id": "pBL*@~^MlzDuNVVxhL2z",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "GTE"
                    },
                    "id": "HA,HDX^0[:)c21RTDVj[",
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
                          "id": "#ybhB/M/L/[WitW%kyp[",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "+Z]3Z!)S-.MdCT~HQL/6",
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
                    "id": "qT7RSHxf|=O60cOQpH@S",
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
                          "id": "8*+BF}(93S{4WZ`#CF|L",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 3
                          },
                          "id": "H#?E^Vd*)v$.U`R)XJ7W",
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
        "x": 75,
        "y": 975
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
                        "id": "v6v%VeAD~CVszb{{E;,.",
                        "inputs": {
                          "TEXT": {
                            "block": {
                              "fields": {
                                "TEXT": "Boss spawn!"
                              },
                              "id": "C,r?U#aeM~.OX=`N$*Hx",
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
                            "id": "T)ErvxVYP*JiUNr0?Jt8",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "extraState": "<mutation></mutation>",
                                  "fields": {
                                    "TYPE": "board",
                                    "VAR": {
                                      "id": "RhS}la*Ih8_=p,@#59FR"
                                    }
                                  },
                                  "id": "EId(%]IACR_#`o=wlVLM",
                                  "type": "variables_get"
                                }
                              },
                              "ARG2": {
                                "block": {
                                  "fields": {
                                    "OP": "ADD"
                                  },
                                  "id": "lp=}Ne{GI|jJ2Da^UvOP",
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
                                        "id": "|3pX)NYEbpfEeI=}?FL7",
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
                                        "id": "en|2s,TKBicrqX%b@h5K",
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
                                              "id": "|P?Jt)V?HwLC32yJ/F0z",
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
                                              "id": "r}K5}z},UiOO;PI!4yfa",
                                              "inputs": {
                                                "A": {
                                                  "block": {
                                                    "fields": {
                                                      "OP": "ADD"
                                                    },
                                                    "id": "I3Xl$d%N16`exv}pfSgF",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "fields": {
                                                            "THIS": false,
                                                            "VAR": "unitVariable:VelocityX"
                                                          },
                                                          "id": "3Xu)mGhoE:@k2Zuoj*;p",
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
                                                          "id": "6[uca[-G(uXWr=~.`_cg",
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
                                                    "id": "`X|2NWdYh4MR;]d72ds_",
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
                                  "id": "31KldoE8T$K{}540XK5(",
                                  "type": "math_number"
                                }
                              },
                              "ARG5": {
                                "block": {
                                  "fields": {
                                    "VAR": "Enemy"
                                  },
                                  "id": "yfqICh_BQ6h8hW9YTwZ0",
                                  "type": "teamtag_get"
                                }
                              },
                              "ARG6": {
                                "block": {
                                  "fields": {
                                    "NUM": 1
                                  },
                                  "id": "sX;qeOWPi6-Y2dp$U~#W",
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
                                "id": "0//aLyY+;/!bE8Ya)*c%",
                                "inputs": {
                                  "VALUE": {
                                    "block": {
                                      "fields": {
                                        "NUM": 1
                                      },
                                      "id": "Eq_kwdvE=NJ{#R2vcG?U",
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
        "type": "controls_if",
        "x": 65,
        "y": 5375
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
                                    "id": "RhS}la*Ih8_=p,@#59FR"
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
        "x": 65,
        "y": 6035
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
        "x": 65,
        "y": 165
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Map_Default4_Wave4",
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
      "id": "]k(O@*rBv!(l1#TZ].Up",
      "name": "Gem"
    },
    {
      "id": "a2+z%9LxrAPFb1zjG0bW",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "g0,Syv!5uD33Vx2Ec;Qp",
      "name": "Map/Player/Moving"
    },
    {
      "id": "d#ylD=~G9IVVhiW.ZU2]",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "eq0jTyggyX+AgK[HR#yO",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "s:=KV)af3Q8o{,JJ$75|",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "RWQ3II^dHk7@a_Vixvw/",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "Mz36BH!kI!B)Wp-dEMNw",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "LZ0j$!C4m=ye~{^TMbcy",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "ktgr!C*=s5x4JPht0|aC",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "Cr@;=!b#8Ebo])m.KU!$",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "hKZy?fHZI3|9;J;kQ0~n",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "5Z:S!|Al%e9?1Yi{X%zx",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "lj2y?;iv,R-znXI[fnwh",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "~5Sl8H/wZ5W577H(UUO8",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "hpt1?azueP(V$fmKQClH",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "R{~+qKpzYoWU%m=wK_(J",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "o]:Wh{}#8n+Cg9BC1EJY",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "G[*g/kEYrM=ftZ,Cp%v[",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "Su#SY}UaeK4A9CjP,QjR",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "^x,+:`j-D[u(OT!X$)iJ",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "P}xLoK)^Gu^/PlDIQ):{",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": ",EQ?$IA0NZO#?jC|fusW",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "Ixi.btHm*]1F#CMxK9*]",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": ":X)-[Ka9rdJ|(Zo=ikHc",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "em1Sm8}s/bIT[N0@=Ox/",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "oCj2.j(XPa4)+B.^[4q,",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "{x@:7zi`*L)YSjr_3$Pb",
      "name": "@Map/Progress"
    },
    {
      "id": "[n@,4Kuivulr5MdJdoWp",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "Y$)Nn~LsO~IfQ^}weAzm",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "A4@jtoq#s0:WGjK1AK^V",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "F*aBb%z:a:-n1;d7JwUD",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "!k`2yS/Uq`,yB*:*c^A~",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "wJL`0E6_F1#@E^]4$B}0",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "TdF9ETv2{DE+q}5^yO|v",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "3ckHbP:q4S;lKt96|W`+",
      "name": "Map/DisplayWinningTeam"
    },
    {
      "id": "vB]dsA#;OL@I4I)S%s|N",
      "name": "🚨 Scout rewards maxed out!\nCollect Gold💰 & Gems💎, and power up!\nPlay Hamster Combat now! 👉 [Play Now]"
    },
    {
      "id": "3ZM*n~^aI*InR(`k;2OR",
      "name": "@Map/WaveStartPlayerPosition"
    }
  ]
}