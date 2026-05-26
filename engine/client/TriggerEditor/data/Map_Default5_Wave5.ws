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
                      "NUM": 5
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
        "x": 745,
        "y": -3315
      },
      {
        "id": "fjrAVy@Vvmy-V,t1!+hG",
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
                            "NUM": 1575
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
                  "id": "aD8291):?q(Z:rJW!Zo{",
                  "inputs": {
                    "DO0": {
                      "block": {
                        "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                        "fields": {
                          "NAME": "boardMethod:ShowPopup",
                          "THIS": false
                        },
                        "id": "JLt)aSNxXu0NnC7!%u?%",
                        "inputs": {
                          "TEXT": {
                            "block": {
                              "fields": {
                                "TEXT": "Popup_BigWaveAlert"
                              },
                              "id": "*}m2a/@78pZ+ewAR,dJ}",
                              "type": "text"
                            }
                          },
                          "VAR1": {
                            "block": {
                              "fields": {
                                "NUM": 0
                              },
                              "id": "8E06I92SQ`cW}6$u@4?4",
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
                        "id": "43jR$O-!Dn8,Ui}d;epu",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "OP": "MINUS"
                              },
                              "id": ")?`{]HmoA5aoqos]BJ7r",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "THIS": false,
                                      "VAR": "boardVariable:Tick"
                                    },
                                    "id": "R,UK|];nTyStr%_j~KdI",
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
                                    "id": "upWKA2Q7~=S5..Q)R!c6",
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
                              "id": "oSBi!BzukVt=cZTWMUIG",
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
                                                  "id": "0:3^ZP[iNRYDvtqd,2C."
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
                                              "id": "j!9{STnBT4Pg{vUK$xsz",
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
                                                    "id": "|v0}{k+nU3T:bP5n7]^~",
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
                                                    "id": "xSoA5iA:,i3VB^9)1ly.",
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
                                                          "id": "v)~kpdPHRp[D?iHP~ZWp",
                                                          "inputs": {
                                                            "A": {
                                                              "block": {
                                                                "fields": {
                                                                  "OP": "ADD"
                                                                },
                                                                "id": "bSv+c7GL0~;-EunLR(Wt",
                                                                "inputs": {
                                                                  "A": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "THIS": false,
                                                                        "VAR": "unitVariable:VelocityX"
                                                                      },
                                                                      "id": "[+zsUV7cj]ffxFFyU/)K",
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
                                                                      "id": "ujhHBoFHC#E{$V87t_D8",
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
                                                                "id": "*lNDM7-DNwuGSz)=Ehs4",
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
                                                      "id": "0:3^ZP[iNRYDvtqd,2C."
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
                                                  "id": "u6pTx(*PFxxjgrMh};.%",
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
                                                        "id": "H9sv}DLWc90s@?$!l`m:",
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
                                                        "id": "$h#@x9*}$p6_D/jZZ}nw",
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
                                                              "id": "u3yUqMRcY$fBz8;A3=+v",
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
                                                              "id": "ArlT-YLT[qKBqc2t}W1`",
                                                              "inputs": {
                                                                "A": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "OP": "ADD"
                                                                    },
                                                                    "id": "d#%iTDFTHa?02?S9:~4_",
                                                                    "inputs": {
                                                                      "A": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "THIS": false,
                                                                            "VAR": "unitVariable:VelocityX"
                                                                          },
                                                                          "id": "{DWsSQ6Wh;A9s,^BMs|o",
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
                                                                          "id": "*Li37MyeN+w6dY8GF5R4",
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
                                                                    "id": "6Y%|^YABiwquV#Wz@k,^",
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
                                                          "id": "P4zNZ3urx?P8!wfni_w*"
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
                                                      "id": "/W1k9K65je8z[$D{XN1Y",
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
                                                            "id": "XW`ye$:Bm5t5j*9J7^x(",
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
                                                            "id": "C#F_iC#{_)p7tbb4QDIS",
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
                                                                  "id": "0_Y9Sj#;6EdGdj9eUrEc",
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
                                                                  "id": "3}2IN0hDf)/s4wnudV]d",
                                                                  "inputs": {
                                                                    "A": {
                                                                      "block": {
                                                                        "fields": {
                                                                          "OP": "ADD"
                                                                        },
                                                                        "id": "vDEhe}{?JCCqIbHlV6B8",
                                                                        "inputs": {
                                                                          "A": {
                                                                            "block": {
                                                                              "fields": {
                                                                                "THIS": false,
                                                                                "VAR": "unitVariable:VelocityX"
                                                                              },
                                                                              "id": "(^5`w)0:x1|nem:E;):h",
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
                                                                              "id": "{F-=t=^3/B}=emhl|y7F",
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
                                                                        "id": "3ErPWX^]zgo2@.5R_MOx",
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
                                                              "NUM": 210
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
                                  "id": "j;L6tjpVHq+}1g~FH~tN",
                                  "inputs": {
                                    "DO0": {
                                      "block": {
                                        "id": "jkfxBJ18e9,^F)4-]CD0",
                                        "inputs": {
                                          "DO0": {
                                            "block": {
                                              "id": "#Sxv8qx;}vt7:h#lYmsI",
                                              "inputs": {
                                                "DO0": {
                                                  "block": {
                                                    "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                    "fields": {
                                                      "NAME": "boardMethod:AddUnit",
                                                      "THIS": true
                                                    },
                                                    "id": "_8^pHb]f-E.,)W7jjM6;",
                                                    "inputs": {
                                                      "ARG0": {
                                                        "block": {
                                                          "extraState": "<mutation></mutation>",
                                                          "fields": {
                                                            "TYPE": "board",
                                                            "VAR": {
                                                              "id": "~h-l?]MmsIeEupel/_a#"
                                                            }
                                                          },
                                                          "id": "=?le?k/k1oRB}eT]%}Gv",
                                                          "type": "variables_get"
                                                        }
                                                      },
                                                      "ARG2": {
                                                        "block": {
                                                          "fields": {
                                                            "OP": "ADD"
                                                          },
                                                          "id": "$pivIaQq,7n8{vL6w~!?",
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
                                                                "id": "p(752$_lg~5FC8MLF:30",
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
                                                                "id": "7xLtG]Dlk~(kntHi9lrj",
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
                                                                      "id": "pHMAU,N078`.#67`xo[$",
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
                                                                      "id": "o}@UD4*x|(J4c0+XA6+3",
                                                                      "inputs": {
                                                                        "A": {
                                                                          "block": {
                                                                            "fields": {
                                                                              "OP": "ADD"
                                                                            },
                                                                            "id": ".J1[:NMpFb5wS0Y.79|A",
                                                                            "inputs": {
                                                                              "A": {
                                                                                "block": {
                                                                                  "fields": {
                                                                                    "THIS": false,
                                                                                    "VAR": "unitVariable:VelocityX"
                                                                                  },
                                                                                  "id": "N;W@(V?emCR0X$h57.SS",
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
                                                                                  "id": "Jo+K7zCXflHB;aLXSE$6",
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
                                                                            "id": "%r3Km[2.W(Pyn:Mx#_8v",
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
                                                          "id": ":9WW+qSLoRln@tCT{aF)",
                                                          "type": "math_number"
                                                        }
                                                      },
                                                      "ARG5": {
                                                        "block": {
                                                          "fields": {
                                                            "VAR": "Enemy"
                                                          },
                                                          "id": "7,ln:`mQkuQx34pppVr{",
                                                          "type": "teamtag_get"
                                                        }
                                                      },
                                                      "ARG6": {
                                                        "block": {
                                                          "fields": {
                                                            "NUM": 1
                                                          },
                                                          "id": "O**]7f^+ADAG!j)b?gm2",
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
                                                    "id": "cTl$e(]v=n%LtKgtLI_N",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "id": "d)z{tG[M%4;NZwlWpPvM",
                                                          "inputs": {
                                                            "DIVIDEND": {
                                                              "block": {
                                                                "fields": {
                                                                  "OP": "MINUS"
                                                                },
                                                                "id": "Qtz}km}3CNAu2e*lq1LO",
                                                                "inputs": {
                                                                  "A": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "THIS": false,
                                                                        "VAR": "boardVariable:Tick"
                                                                      },
                                                                      "id": "N[LY~Pj,A^LvX5GJb3?!",
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
                                                                      "id": "WPfOKHD5Ow]2f=6,MKQn",
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
                                                                "id": "ZRkE/gTZ1Fw2Y8bFDLBk",
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
                                                          "id": "5TEW;o_d*wE?:q{.w`KY",
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
                                              "id": "%JqJ4,u!pE-N~W4-OrQQ",
                                              "inputs": {
                                                "A": {
                                                  "block": {
                                                    "fields": {
                                                      "OP": "MINUS"
                                                    },
                                                    "id": "I/e||X?^SYA1}QeDBL6M",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "fields": {
                                                            "THIS": false,
                                                            "VAR": "boardVariable:Tick"
                                                          },
                                                          "id": "8#Z58o%`N,0^PZo9=$Y1",
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
                                                          "id": "HJqGpsy0T@KR)RS~j[;l",
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
                                                    "id": "quXx}lRH|cw:DTVx.CTK",
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
                                        "id": "mztft~)g|*lWl;B[nKTG",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "OP": "MINUS"
                                              },
                                              "id": "p{5Y-$R)xJ@8H4*gYUp5",
                                              "inputs": {
                                                "A": {
                                                  "block": {
                                                    "fields": {
                                                      "THIS": false,
                                                      "VAR": "boardVariable:Tick"
                                                    },
                                                    "id": "]lun(@t|OihFiJ7Zhk}(",
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
                                                    "id": "52v7_Bk3=/_$w84SV9/O",
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
                                                "NUM": 525
                                              },
                                              "id": "z$YI7$@3+a;Qaq=/|CO(",
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
                                      "id": "y-p,XDUQG1;~:9`F9/)|",
                                      "inputs": {
                                        "DO0": {
                                          "block": {
                                            "id": "kiZ((G7]BM0-gY5};ot(",
                                            "inputs": {
                                              "DO0": {
                                                "block": {
                                                  "id": "mF7B7i}:Gk1cPtja2C1m",
                                                  "inputs": {
                                                    "DO0": {
                                                      "block": {
                                                        "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                        "fields": {
                                                          "NAME": "boardMethod:AddUnit",
                                                          "THIS": true
                                                        },
                                                        "id": "JELp*0C|r_nR}=m3Q9fN",
                                                        "inputs": {
                                                          "ARG0": {
                                                            "block": {
                                                              "extraState": "<mutation></mutation>",
                                                              "fields": {
                                                                "TYPE": "board",
                                                                "VAR": {
                                                                  "id": "P4zNZ3urx?P8!wfni_w*"
                                                                }
                                                              },
                                                              "id": "/D@WJDEh.I^TpN$Pj2hz",
                                                              "type": "variables_get"
                                                            }
                                                          },
                                                          "ARG2": {
                                                            "block": {
                                                              "fields": {
                                                                "OP": "ADD"
                                                              },
                                                              "id": "XW?Z[MtA]Y22tuc:8,YS",
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
                                                                    "id": "U9Vh,YVs95GI7|?RKU!)",
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
                                                                    "id": "##a0-(j6Lde$76:[+R}P",
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
                                                                          "id": "$kLcO;[hRU8mv)3pA;_0",
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
                                                                          "id": "xe1rupY.#^K@!g]rbKID",
                                                                          "inputs": {
                                                                            "A": {
                                                                              "block": {
                                                                                "fields": {
                                                                                  "OP": "ADD"
                                                                                },
                                                                                "id": "0ZUGcwgKQw;u0-fu6fk9",
                                                                                "inputs": {
                                                                                  "A": {
                                                                                    "block": {
                                                                                      "fields": {
                                                                                        "THIS": false,
                                                                                        "VAR": "unitVariable:VelocityX"
                                                                                      },
                                                                                      "id": ",LaPwW1@C6!$s|qZqWK,",
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
                                                                                      "id": "4Cepj.rT#rYYab;W:oSv",
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
                                                                                "id": ":3ol13J=Cn9V#+@E35RH",
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
                                                              "id": ";G1[fT__V/7r%_It~XsN",
                                                              "type": "math_number"
                                                            }
                                                          },
                                                          "ARG5": {
                                                            "block": {
                                                              "fields": {
                                                                "VAR": "Enemy"
                                                              },
                                                              "id": "c(Z(.p_*.HKe-nB[JCU`",
                                                              "type": "teamtag_get"
                                                            }
                                                          },
                                                          "ARG6": {
                                                            "block": {
                                                              "fields": {
                                                                "NUM": 1
                                                              },
                                                              "id": "e6Y{XJyA0y8AoPBi*qCj",
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
                                                        "id": "O1_WYQ!gw}Nl2R+s!R@m",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "id": "}]WXwGn`s5~0V/?^5D-o",
                                                              "inputs": {
                                                                "DIVIDEND": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "OP": "MINUS"
                                                                    },
                                                                    "id": ")6`0}Rb[VKm:g:7q`I%]",
                                                                    "inputs": {
                                                                      "A": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "THIS": false,
                                                                            "VAR": "boardVariable:Tick"
                                                                          },
                                                                          "id": ",*[mbn=.KE1Hzd~VilPS",
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
                                                                          "id": "haVRjpA!gBJ~0{-ZVZjQ",
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
                                                                    "id": "ZPAOeQMb;ASTi9}.upPl",
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
                                                              "id": "witqcvvIvWrvX@#QB5p-",
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
                                                  "id": "D{FS=E|AffJ/yRZ(|^BM",
                                                  "inputs": {
                                                    "A": {
                                                      "block": {
                                                        "fields": {
                                                          "OP": "MINUS"
                                                        },
                                                        "id": "fS?2G}=QXpLnKdV?U,H4",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "fields": {
                                                                "THIS": false,
                                                                "VAR": "boardVariable:Tick"
                                                              },
                                                              "id": "4$gOUIvmG?bm#NEkoGZ7",
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
                                                              "id": "/W5-8-l]V9`-sdIrHQFl",
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
                                                        "id": "}mS9fl{eRlJ/,L6%=}+F",
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
                                            "id": "^BTa%b(lmzcqYb6X){A7",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "fields": {
                                                    "OP": "MINUS"
                                                  },
                                                  "id": "mDf{Zmo+#7o.b+BH.uWd",
                                                  "inputs": {
                                                    "A": {
                                                      "block": {
                                                        "fields": {
                                                          "THIS": false,
                                                          "VAR": "boardVariable:Tick"
                                                        },
                                                        "id": "(szIv3#ATh~~EX0Q$HI+",
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
                                                        "id": "{3~CXu7!B_-$gmiDY8M,",
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
                                                  "id": "y?D$wAx71@gl#KDoDWM)",
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
                                          "id": "3NZUD623HC/t@|K)O0]M",
                                          "inputs": {
                                            "DO0": {
                                              "block": {
                                                "id": "T0BC]qZD!=DT.PL7p37[",
                                                "inputs": {
                                                  "DO0": {
                                                    "block": {
                                                      "id": "M9a}mHeynSNIR6F9C5eR",
                                                      "inputs": {
                                                        "DO0": {
                                                          "block": {
                                                            "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                            "fields": {
                                                              "NAME": "boardMethod:AddUnit",
                                                              "THIS": true
                                                            },
                                                            "id": "]}kF6^4@uVW]YSxKuqCV",
                                                            "inputs": {
                                                              "ARG0": {
                                                                "block": {
                                                                  "extraState": "<mutation></mutation>",
                                                                  "fields": {
                                                                    "TYPE": "board",
                                                                    "VAR": {
                                                                      "id": "HayB1z.{}@fnumMb9][f"
                                                                    }
                                                                  },
                                                                  "id": "rMN/_e?%~!z[A1h`5:|(",
                                                                  "type": "variables_get"
                                                                }
                                                              },
                                                              "ARG2": {
                                                                "block": {
                                                                  "fields": {
                                                                    "OP": "ADD"
                                                                  },
                                                                  "id": "Y7raSo;_1WL-gKx.;c8L",
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
                                                                        "id": "G)?h:q~c*kT,*lYlA*[_",
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
                                                                        "id": "@=X$+tXqf/oYWz{YZBgP",
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
                                                                              "id": "57rG:?x.dN6T!DZGSAog",
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
                                                                              "id": ";$D{{KXZ?wD8YoB^zb7t",
                                                                              "inputs": {
                                                                                "A": {
                                                                                  "block": {
                                                                                    "fields": {
                                                                                      "OP": "ADD"
                                                                                    },
                                                                                    "id": "WOk|vUEDE7{,DQ-DmhWr",
                                                                                    "inputs": {
                                                                                      "A": {
                                                                                        "block": {
                                                                                          "fields": {
                                                                                            "THIS": false,
                                                                                            "VAR": "unitVariable:VelocityX"
                                                                                          },
                                                                                          "id": "rs[S7MOi!xe4FhY(ALB,",
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
                                                                                          "id": "(dVM|*IPww($e%D-Nmx7",
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
                                                                                    "id": "#fbA_euQmT5Y%Ie~EWT4",
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
                                                                  "id": "lsj4vorP1wGwSqX5S@?W",
                                                                  "type": "math_number"
                                                                }
                                                              },
                                                              "ARG5": {
                                                                "block": {
                                                                  "fields": {
                                                                    "VAR": "Enemy"
                                                                  },
                                                                  "id": "~OMP*|j9MD%wV#_mPJqJ",
                                                                  "type": "teamtag_get"
                                                                }
                                                              },
                                                              "ARG6": {
                                                                "block": {
                                                                  "fields": {
                                                                    "NUM": 1
                                                                  },
                                                                  "id": "[/SHJDIjF2]Rl=%_Iy8g",
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
                                                            "id": "|bBK#+bxg8T9qEcMXH81",
                                                            "inputs": {
                                                              "A": {
                                                                "block": {
                                                                  "id": "psQ^7GE%*p~gP=VV5M^v",
                                                                  "inputs": {
                                                                    "DIVIDEND": {
                                                                      "block": {
                                                                        "fields": {
                                                                          "OP": "MINUS"
                                                                        },
                                                                        "id": "*m-h4~V0)~](-v!jD/O^",
                                                                        "inputs": {
                                                                          "A": {
                                                                            "block": {
                                                                              "fields": {
                                                                                "THIS": false,
                                                                                "VAR": "boardVariable:Tick"
                                                                              },
                                                                              "id": "90(.ewJq3Zbvxg;^.@Jo",
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
                                                                              "id": "B5F:;0oT#6PB:mmhs@v~",
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
                                                                        "id": "-*%3)h]YlY,:*0,lgR#r",
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
                                                                  "id": "5ec~AWMo76qE^~yv][=#",
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
                                                      "id": "lV}qUJs|V+r|eRVgKu}e",
                                                      "inputs": {
                                                        "A": {
                                                          "block": {
                                                            "fields": {
                                                              "OP": "MINUS"
                                                            },
                                                            "id": "S@jt?4%;8U[!%,I7?4G?",
                                                            "inputs": {
                                                              "A": {
                                                                "block": {
                                                                  "fields": {
                                                                    "THIS": false,
                                                                    "VAR": "boardVariable:Tick"
                                                                  },
                                                                  "id": "mf?LB#tneL5ame^*0nq?",
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
                                                                  "id": "R.Q-Ai;.,hx.X]4W%GB~",
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
                                                            "id": "7u.FrJLfq}fn9CB=l88F",
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
                                                "id": "?5nYS/`F2}uYh`}KLbbt",
                                                "inputs": {
                                                  "A": {
                                                    "block": {
                                                      "fields": {
                                                        "OP": "MINUS"
                                                      },
                                                      "id": "pK@X4_6E;F7,x_Dr:-|?",
                                                      "inputs": {
                                                        "A": {
                                                          "block": {
                                                            "fields": {
                                                              "THIS": false,
                                                              "VAR": "boardVariable:Tick"
                                                            },
                                                            "id": "(k[jC|,q|jK/p9vL4hS0",
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
                                                            "id": "a8.ocxah0vesS`)R]3E-",
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
                                                        "NUM": 555
                                                      },
                                                      "id": "3Xs*Qj0XY5E@^TfTlm;G",
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
                                              "id": "QtaUhj!fu(4mc_?N+s?)",
                                              "inputs": {
                                                "DO0": {
                                                  "block": {
                                                    "id": "+1hhsLiOh.?sGR`L~e|[",
                                                    "inputs": {
                                                      "DO0": {
                                                        "block": {
                                                          "id": "A7za:=/iuDL`qCqu07xA",
                                                          "inputs": {
                                                            "DO0": {
                                                              "block": {
                                                                "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                                "fields": {
                                                                  "NAME": "boardMethod:AddUnit",
                                                                  "THIS": true
                                                                },
                                                                "id": "K;J!?o2ntU(}R0jJ0Pz!",
                                                                "inputs": {
                                                                  "ARG0": {
                                                                    "block": {
                                                                      "extraState": "<mutation></mutation>",
                                                                      "fields": {
                                                                        "TYPE": "board",
                                                                        "VAR": {
                                                                          "id": "P4zNZ3urx?P8!wfni_w*"
                                                                        }
                                                                      },
                                                                      "id": "fVr1z$ffSzeI`4Ab!uAd",
                                                                      "type": "variables_get"
                                                                    }
                                                                  },
                                                                  "ARG2": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "OP": "ADD"
                                                                      },
                                                                      "id": "%YEr)GA_Cr^.36`Kj?~9",
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
                                                                            "id": "@}IePJPocEc^I,4rk@jA",
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
                                                                            "id": "4}Q*i={|sVPq6u%j.aWy",
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
                                                                                  "id": "wKK63e47tywuPwksA4`9",
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
                                                                                  "id": "?x|@C!N6zpQVu=~FpjGZ",
                                                                                  "inputs": {
                                                                                    "A": {
                                                                                      "block": {
                                                                                        "fields": {
                                                                                          "OP": "ADD"
                                                                                        },
                                                                                        "id": "uVJtUsHiirwYHB,9#B_8",
                                                                                        "inputs": {
                                                                                          "A": {
                                                                                            "block": {
                                                                                              "fields": {
                                                                                                "THIS": false,
                                                                                                "VAR": "unitVariable:VelocityX"
                                                                                              },
                                                                                              "id": "JUKn`Q7-!V_4r=9O|.`e",
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
                                                                                              "id": "`7_aafS3P5La3m~3V1vg",
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
                                                                                        "id": "]^R8Wq;ow?Nf~FgUo%(j",
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
                                                                      "id": "rffs1^[MbgSwu[ustRT1",
                                                                      "type": "math_number"
                                                                    }
                                                                  },
                                                                  "ARG5": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "VAR": "Enemy"
                                                                      },
                                                                      "id": "+B4_i6jpbVF(5?OJjBEZ",
                                                                      "type": "teamtag_get"
                                                                    }
                                                                  },
                                                                  "ARG6": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "NUM": 1
                                                                      },
                                                                      "id": "ouq-8R?=:u(SbiLVZ]^f",
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
                                                                "id": "7`DdIG`xrZ13a7=kZ:Zx",
                                                                "inputs": {
                                                                  "A": {
                                                                    "block": {
                                                                      "id": "*l@6eeQhQ6x4-/H%4Sjj",
                                                                      "inputs": {
                                                                        "DIVIDEND": {
                                                                          "block": {
                                                                            "fields": {
                                                                              "OP": "MINUS"
                                                                            },
                                                                            "id": "/#U(2wQl:#yW_w0+0emB",
                                                                            "inputs": {
                                                                              "A": {
                                                                                "block": {
                                                                                  "fields": {
                                                                                    "THIS": false,
                                                                                    "VAR": "boardVariable:Tick"
                                                                                  },
                                                                                  "id": "t`hAL?yz}cj`,oY8v#!v",
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
                                                                                  "id": "-6kdpw$9D3JpK]UD+fQ1",
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
                                                                            "id": "Ga+e)S!HVB/+[ySr2E5{",
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
                                                                      "id": "~4PXjWjk8nT_NW#0|KG^",
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
                                                          "id": "K((owRIl*@Y-!df=.=m^",
                                                          "inputs": {
                                                            "A": {
                                                              "block": {
                                                                "fields": {
                                                                  "OP": "MINUS"
                                                                },
                                                                "id": "kpZF,`Ev;#!cS#:z~7;P",
                                                                "inputs": {
                                                                  "A": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "THIS": false,
                                                                        "VAR": "boardVariable:Tick"
                                                                      },
                                                                      "id": "}h^dEuk)0A?3#owI1UB?",
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
                                                                      "id": "(V$-j1xQSEXj-O%JU-QY",
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
                                                                "id": "dHa9Sw0:5Md3Q@MR9Eag",
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
                                                    "id": "/Dl1-8[#y-J0fv`,vjU;",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "fields": {
                                                            "OP": "MINUS"
                                                          },
                                                          "id": ";_k;yc`lLQkLsGH6wC)g",
                                                          "inputs": {
                                                            "A": {
                                                              "block": {
                                                                "fields": {
                                                                  "THIS": false,
                                                                  "VAR": "boardVariable:Tick"
                                                                },
                                                                "id": "*mHT~FIDo-Kla5]oL[Ab",
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
                                                                "id": "orUgN?K]8~;@j-:y2qRu",
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
                                                          "id": "NC+`}mr/TP1m;VSWS0u]",
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
                                                  "id": "xofNstIc7Dsdf,ly_x%e",
                                                  "inputs": {
                                                    "DO0": {
                                                      "block": {
                                                        "id": "Un9sIj[uonxXCuPWE=iw",
                                                        "inputs": {
                                                          "DO0": {
                                                            "block": {
                                                              "id": "xq/EM8Z?]6-a1wt8T@`z",
                                                              "inputs": {
                                                                "DO0": {
                                                                  "block": {
                                                                    "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                                    "fields": {
                                                                      "NAME": "boardMethod:AddUnit",
                                                                      "THIS": true
                                                                    },
                                                                    "id": "b[EByq^GQ?*z[1sDI*TH",
                                                                    "inputs": {
                                                                      "ARG0": {
                                                                        "block": {
                                                                          "extraState": "<mutation></mutation>",
                                                                          "fields": {
                                                                            "TYPE": "board",
                                                                            "VAR": {
                                                                              "id": "tp@DPL517ZQ!|^jn]yz`"
                                                                            }
                                                                          },
                                                                          "id": "-YP_(3Daq0(j/1iU,#Bt",
                                                                          "type": "variables_get"
                                                                        }
                                                                      },
                                                                      "ARG2": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "OP": "ADD"
                                                                          },
                                                                          "id": "kV3tT$T}/n@5qQv*mHC,",
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
                                                                                "id": "1V1M4|7u0=kQ)2v,xwfr",
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
                                                                                "id": "CG^]IzN1eX8gBc|.i0g5",
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
                                                                                      "id": "gYCAIa8jz[nQkeIYO1/Z",
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
                                                                                      "id": "T2T7c1u@{D!9xd@c$JOi",
                                                                                      "inputs": {
                                                                                        "A": {
                                                                                          "block": {
                                                                                            "fields": {
                                                                                              "OP": "ADD"
                                                                                            },
                                                                                            "id": "N{b5vL3H+Wb@=-MbB$;q",
                                                                                            "inputs": {
                                                                                              "A": {
                                                                                                "block": {
                                                                                                  "fields": {
                                                                                                    "THIS": false,
                                                                                                    "VAR": "unitVariable:VelocityX"
                                                                                                  },
                                                                                                  "id": "dD6{Algrm7f.vti4#~O=",
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
                                                                                                  "id": "y?+e?J2yA22Adg{Tb_jT",
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
                                                                                            "id": "uF`l8DFd~K!l(0=^VY=[",
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
                                                                          "id": "7nZmXi$,/,^Zz[DFtOEx",
                                                                          "type": "math_number"
                                                                        }
                                                                      },
                                                                      "ARG5": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "VAR": "Enemy"
                                                                          },
                                                                          "id": "|RT%PzhA7Ol4@}M.B]:P",
                                                                          "type": "teamtag_get"
                                                                        }
                                                                      },
                                                                      "ARG6": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "NUM": 1
                                                                          },
                                                                          "id": "{K-rVO)ol;/j8X=$dj@G",
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
                                                                    "id": "mV3`tDFxJ=gm2^.mokgN",
                                                                    "inputs": {
                                                                      "A": {
                                                                        "block": {
                                                                          "id": "a{aQp%[sOJsR0XQ9@[=(",
                                                                          "inputs": {
                                                                            "DIVIDEND": {
                                                                              "block": {
                                                                                "fields": {
                                                                                  "OP": "MINUS"
                                                                                },
                                                                                "id": "GB6mKLRRomd1LP2;GJAt",
                                                                                "inputs": {
                                                                                  "A": {
                                                                                    "block": {
                                                                                      "fields": {
                                                                                        "THIS": false,
                                                                                        "VAR": "boardVariable:Tick"
                                                                                      },
                                                                                      "id": ",hg389X0C+#^4{7?{p;H",
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
                                                                                      "id": "2y?Qz#FG/Ay_)$X?-=p-",
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
                                                                                "id": "3+Vh%NPaP`ITR81pkQC2",
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
                                                                          "id": "1{Ofs(q~9XbQnmFxdN0P",
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
                                                              "id": "}!]~4}XwuJE^xtsMz*T?",
                                                              "inputs": {
                                                                "A": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "OP": "MINUS"
                                                                    },
                                                                    "id": ",}1L~=`UFqx62@Q:?qj=",
                                                                    "inputs": {
                                                                      "A": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "THIS": false,
                                                                            "VAR": "boardVariable:Tick"
                                                                          },
                                                                          "id": "RJcCp-24n+,`%r%va4#^",
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
                                                                          "id": "0F_CzU81okrF8Y-k+?}|",
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
                                                                    "id": "]=D+5#$3$wx_;MJxRg}l",
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
                                                        "id": "c_[S7/u;,K}(]-LjwIsa",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "fields": {
                                                                "OP": "MINUS"
                                                              },
                                                              "id": "))3ywluAo3|BN1u%NMTE",
                                                              "inputs": {
                                                                "A": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "THIS": false,
                                                                      "VAR": "boardVariable:Tick"
                                                                    },
                                                                    "id": "P!d^06T89d:e,9Wp*KTF",
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
                                                                    "id": "U]_Y?A#EDl?D]kf4[~la",
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
                                                              "id": "1a[GB/v8lmPAIn5h8C(p",
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
              "id": ".O?2LpJd)4KndI*tPKx;",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "GTE"
                    },
                    "id": "195HPR%BvP.bkB18+3rU",
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
                          "id": "DOgt1Jg42#cegXnmDHPI",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "t-]WXGXq@/vD%k*O4(Fa",
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
                    "id": "b~61NMknwR,f51oy)x6s",
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
                          "id": "2#e:FsIRQ$Pr]L+++Pp5",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 3
                          },
                          "id": "1g[];E/=6JijsQi3]pB/",
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
        "x": 735,
        "y": -1655
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
            "id": "gp.3vsmc7U;Z1=5XD$!!",
            "inputs": {
              "DO0": {
                "block": {
                  "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Duration (필수)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "boardMethod:StartTimer",
                    "THIS": false
                  },
                  "id": "0~WjhlTQpB~zsD@^dDXv",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "fields": {
                          "NUM": 1
                        },
                        "id": "xQlTfG_Tzj*_@Kj#7POd",
                        "type": "math_number"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "fields": {
                        "TYPE": "board",
                        "VAR": {
                          "id": "yC(b(,q#Lj:E]/`h0DAq"
                        }
                      },
                      "id": "BQfK*|gWt;Ll4]UA.7a6",
                      "inputs": {
                        "VALUE": {
                          "block": {
                            "fields": {
                              "NUM": 0
                            },
                            "id": "T}.@IUsAk1-ASik`?qNa",
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
                          "id": "I-D-FmQY={m$rm.Av*19",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "NUM": 2
                                },
                                "id": "{P}PK,}!F8kwW3s56(PV",
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
                  "id": ")1dv8^*b#x?7`dgkF+K)",
                  "inputs": {
                    "A": {
                      "block": {
                        "fields": {
                          "OP": "AND"
                        },
                        "id": "~DAPVv]?sO=ZT7(!HeXf",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "THIS": false,
                                "VAR": "unitVariable:HasTarget"
                              },
                              "id": "K=A(Z?.]RO{`0Md*Uwmo",
                              "type": "variables_get_reserved"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "OP": "LTE"
                              },
                              "id": "fQ|~`jfo4t6?b4|Un:VL",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "THIS": false,
                                      "VAR": "unitVariable:TargetDistance"
                                    },
                                    "id": "Qq79FQ*vn1]Ugw-0cO0A",
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
                        "id": ",4)4l{yHevD,sqbX(H0z",
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
                              "id": "1ETPkQ4j-fr?4.XK2,^#",
                              "type": "variables_get"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "CSGna,x}/EihsF8](7U{",
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
                "id": "vUP=2V^d,e9SfN#LdB@P",
                "inputs": {
                  "DO0": {
                    "block": {
                      "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                      "fields": {
                        "NAME": "boardMethod:UnBlockSkillAction",
                        "THIS": false
                      },
                      "id": "!a9Bd5e|^8x]xT.]Y12W",
                      "next": {
                        "block": {
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "F//i`5m5GJ/iAUoeO`l["
                            }
                          },
                          "id": "^%=q:3!!Kd~![T658^m_",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "NUM": 3
                                },
                                "id": "-Ug_5QxEKA99u1];:,|^",
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
                      "id": "6N;xDhxXQ_JfB*o3`,~/",
                      "inputs": {
                        "A": {
                          "block": {
                            "fields": {
                              "OP": "LTE"
                            },
                            "id": "_m-Yzz3I)W6!42%~RyXd",
                            "inputs": {
                              "A": {
                                "block": {
                                  "fields": {
                                    "THIS": false,
                                    "VAR": "boardVariable:Timer"
                                  },
                                  "id": "Szt){?u1wH2B2:A+@ZvX",
                                  "type": "variables_get_reserved"
                                }
                              },
                              "B": {
                                "block": {
                                  "fields": {
                                    "NUM": 0
                                  },
                                  "id": "39cG$UWDlsAf-97oLP[i",
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
                            "id": "p[P30[[{)EJq.`Fe82E`",
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
                                  "id": "N+x,@4i#H_w0gLL{:Y^n",
                                  "type": "variables_get"
                                }
                              },
                              "B": {
                                "block": {
                                  "fields": {
                                    "NUM": 2
                                  },
                                  "id": "K!]pktML[Ud)5_t)nEov",
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
        "x": 735,
        "y": -2135
      },
      {
        "id": ".yIK(=J6FBWpdZecl|T9",
        "inputs": {
          "DO0": {
            "block": {
              "id": "l]1_JW{j23}*xw@[agKX",
              "inputs": {
                "DO0": {
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
                                      "id": "pf!E%!GL}1iW($/~/PoE"
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
                                                  "id": "jKYHQM:)v@h,zTna;:Zi"
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
                                    "id": ":n]+2AmHmLwW!roDGC7G"
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
                    "id": "+^kr$*rK0PbpPgYRfL+0",
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
                          "id": "s#ELkgl!qXOgqcsnPf(,",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "THIS": false,
                            "VAR": "boardVariable:Tick"
                          },
                          "id": "m_O8qzXBi4H;5!}~AaWY",
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
                              "id": "F//i`5m5GJ/iAUoeO`l["
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
                              "id": "F//i`5m5GJ/iAUoeO`l["
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
                                        "id": "pf!E%!GL}1iW($/~/PoE"
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
                            "id": ":n]+2AmHmLwW!roDGC7G"
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
            "type": "controls_if"
          }
        },
        "type": "controls_if",
        "x": 715,
        "y": 2845
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
        "x": 745,
        "y": -2505
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
                      "TEXT": "Default4_Battle_05_01"
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
                  "id": "N#:e{m,^}rh$iTC;p;Kq",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "fields": {
                          "NUM": 2
                        },
                        "id": "CJ;PB7=84cX*-y3gWF/p",
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
        "x": 735,
        "y": -3165
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Map_Default5_Wave5",
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
      "id": "O%s^T?e4z}GUrsxW{%1C",
      "name": "Zem"
    },
    {
      "id": "4AZ??c-+wwI=`toPTxJh",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "l2wK2i:i/F27-1PPtNR!",
      "name": "Gem"
    },
    {
      "id": "e}=G!MWib=)sq)U~aDeY",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "nNHtz*P]Jm^Do=1rl}{v",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "U`);{kXkt@-ZS%2x16EE",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "rH(A}4OPU05euCvV5$h`",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "sURFIiW}-UDnAiyk3^i!",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "c50bzXc5j.N6_(L||#Hr",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "OF/?4Jp(0gU7|/.KF5/C",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "yC(b(,q#Lj:E]/`h0DAq",
      "name": "Map/Player/Moving"
    },
    {
      "id": "-{fVnmbHd`SUc)WuNWMy",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "I(,0U`jrXrb?x.oK;o4u",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "3;+Jm|j)%ZC*wJDmT!=_",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "Smzh8@7+XT)u6Yj,^7!R",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "*j~cGpzOZ+djafd9jrdo",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "{DmimuRC`0Vg-k)si23$",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "(Xtp95nm6O{VF~:^q|4o",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "PDwky`stZx5vvS#!u`@D",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "0)i1Z9,??;f5+mEGPRw!",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "~A{.,DPkE=:8rH36C,~L",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": ",EP*.A]]I//xt*[KX*HL",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "Rhs-=4$[7)xaz_g26,N9",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "RX!{JX.U#v[LF#?nw2Un",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "4%ou1s#v`v5j7Y:XsM#s",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "G.VJkJAu)yr[WN?x~URC",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "`_qpfo0(fVo*T$,z}(#Y",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "`hXH=-MS+|`tkF(=.59w",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "h,tr.n14-NQ9i5c!8Q_]",
      "name": "@Map/Progress"
    },
    {
      "id": "VXFuBrryNg}X^vvS5?qv",
      "name": "Map/DisplayWinningTeam"
    },
    {
      "id": "t;kNtxu@4E!o{@Yjrk8g",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "C{ed%/n+Q9zGv1D{LlXA",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "!X)tKu`yY~6$PDlU-qh0",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "}8deaL[@MkdkwX8P_ZW|",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "3IF59OI.LamVJ7G4NU(4",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "sD7ZR;]gD?k!OejJdrO/",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "-%d:E2A*BMvkXR+YDO%w",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "w!pNm`th1}PO_[_x[5G)",
      "name": "🚨 Scout rewards maxed out!\nCollect Gold💰 & Gems💎, and power up!\nPlay Hamster Combat now! 👉 [Play Now]"
    },
    {
      "id": "pHloxlL#[F9%aKs/}pEI",
      "name": "@Map/WaveStartPlayerPosition"
    }
  ]
}