{
  "blocks": {
    "blocks": [
      {
        "id": "$!h3%6Gq6GNeP]Q4{eDK",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "NAME": "Log"
              },
              "id": "{fo?O/isc18Vso:F@A,3",
              "inputs": {
                "TEXT": {
                  "block": {
                    "fields": {
                      "TEXT": "Battle_01_04"
                    },
                    "id": "Wp4g;U:xKuTQI;5WFHR0",
                    "type": "text"
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
                  "id": "{|bjhv{wP;sGl/^s=_sB",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "NUM": 4
                        },
                        "id": "-6$}/{NI4qSZLWOi#L=F",
                        "type": "math_number"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "fields": {
                        "TYPE": "board",
                        "VAR": {
                          "id": "1_d:cLOn9Hs@h3RdE/[H"
                        }
                      },
                      "id": "jY5lkZe-u]6W({E;ZyL_",
                      "inputs": {
                        "VALUE": {
                          "block": {
                            "fields": {
                              "THIS": false,
                              "VAR": "boardVariable:Tick"
                            },
                            "id": "D+m/3_46j@FebZ#tLBuW",
                            "type": "variables_get_reserved"
                          }
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
              "id": "g?3#=(%uOS#cucV4eCLm",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "xRq]N@6`]nxDCb^8bjO3",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "{3f{M(~=@{l{G2v$+EpC"
                            }
                          },
                          "id": "ff%i#Q9}e--M@rlOm@7I",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 3
                          },
                          "id": "]OD92t5FpvpG]XoywCK2",
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
                      "OP": "GTE"
                    },
                    "id": "|Az#0C(;F[EMV-9D3y,D",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "p$fa/dGq2^3aZsD*mN|x",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "THIS": false,
                                  "VAR": "boardVariable:Tick"
                                },
                                "id": "s{m7~fiTG0oF!Ny8]+{f",
                                "type": "variables_get_reserved"
                              },
                              "shadow": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "{|mc2t$Mrx0|~`1ARf)X",
                                "type": "math_number"
                              }
                            },
                            "B": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "board",
                                  "VAR": {
                                    "id": "1_d:cLOn9Hs@h3RdE/[H"
                                  }
                                },
                                "id": "QXfGX215va{g));r.,0=",
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
                            "NUM": 480
                          },
                          "id": "fQ|Wx$r-+Od=mz;Dcj=f",
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
            "id": "%Ka%NTx)5hguv({su|gW",
            "inputs": {
              "DO0": {
                "block": {
                  "fields": {
                    "NAME": "Log"
                  },
                  "id": "q%MLpA/svKh#.Ywx+Opl",
                  "inputs": {
                    "TEXT": {
                      "block": {
                        "fields": {
                          "TEXT": "Battle_01_04 spawn!"
                        },
                        "id": "69ne}G`rZHWQz@HwYD3m",
                        "type": "text"
                      }
                    },
                    "VAR": {
                      "block": {
                        "extraState": "<mutation></mutation>",
                        "fields": {
                          "TYPE": "board",
                          "VAR": {
                            "id": "1_d:cLOn9Hs@h3RdE/[H"
                          }
                        },
                        "id": "!P[qf`=kt.h~7pSR8d,X",
                        "type": "variables_get"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "id": ",BWT(HmL$!`.1Uhv*r$)",
                      "inputs": {
                        "DO0": {
                          "block": {
                            "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                            "fields": {
                              "NAME": "boardMethod:AddUnit",
                              "THIS": true
                            },
                            "id": "e`9qYw0a9VA`jSZPsrNr",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "extraState": "<mutation></mutation>",
                                  "fields": {
                                    "TYPE": "board",
                                    "VAR": {
                                      "id": "%=P6Pw5JP:;nkVC8s|1~"
                                    }
                                  },
                                  "id": "(0D:tZDJ;#KV^#U?B(Bq",
                                  "type": "variables_get"
                                }
                              },
                              "ARG1": {
                                "block": {
                                  "fields": {
                                    "VAR": "Location/SPAWNAREA_MOB_001"
                                  },
                                  "id": "6avN-/Uf12W]wxm6liZN",
                                  "type": "stringkeys_get"
                                }
                              },
                              "ARG4": {
                                "block": {
                                  "fields": {
                                    "NUM": 0
                                  },
                                  "id": "75@8O`aB|t,j[A/xE%,D",
                                  "type": "math_number"
                                }
                              },
                              "ARG5": {
                                "block": {
                                  "fields": {
                                    "VAR": "Enemy"
                                  },
                                  "id": "t0YY?E*@XNKlh066R]U$",
                                  "type": "teamtag_get"
                                }
                              },
                              "ARG6": {
                                "block": {
                                  "fields": {
                                    "NUM": 1
                                  },
                                  "id": "DiaH0B9Nu0us,!a+@Lc4",
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
                            "id": ",E99S|-P1w]^?]]x/(16",
                            "inputs": {
                              "A": {
                                "block": {
                                  "id": "v}i`Ri[5R)Azo_qc9b]r",
                                  "inputs": {
                                    "DIVIDEND": {
                                      "block": {
                                        "fields": {
                                          "OP": "MINUS"
                                        },
                                        "id": "MUGXPUb*%4R8e9@/m;Fr",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "THIS": false,
                                                "VAR": "boardVariable:Tick"
                                              },
                                              "id": "ITde(GF[b^lnS5[(U];J",
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
                                                  "id": "1_d:cLOn9Hs@h3RdE/[H"
                                                }
                                              },
                                              "id": "^^nWs=ady1Knr1-EOopL",
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
                                          "NUM": 240
                                        },
                                        "id": "-754dBwcqAv^Vvta]qg@",
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
                                  "id": "O:QtV@tV8{r_8aB_C1lx",
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
                          "id": ":xmOzXt?[)B5dHkO./tt",
                          "inputs": {
                            "DO0": {
                              "block": {
                                "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                "fields": {
                                  "NAME": "boardMethod:AddUnit",
                                  "THIS": true
                                },
                                "id": "69Rr}_:DD$3a*(]Lu+~T",
                                "inputs": {
                                  "ARG0": {
                                    "block": {
                                      "extraState": "<mutation></mutation>",
                                      "fields": {
                                        "TYPE": "board",
                                        "VAR": {
                                          "id": ",bT)653^%NmWNmc9-E,j"
                                        }
                                      },
                                      "id": "X`AB9U?9r#hEp)xj}{e0",
                                      "type": "variables_get"
                                    }
                                  },
                                  "ARG1": {
                                    "block": {
                                      "fields": {
                                        "VAR": "Location/SPAWNAREA_MOB_001"
                                      },
                                      "id": "}?e[fL)4$B.n4TtLTp~q",
                                      "type": "stringkeys_get"
                                    }
                                  },
                                  "ARG4": {
                                    "block": {
                                      "fields": {
                                        "NUM": 0
                                      },
                                      "id": "eZa+TseN=@dUc@jI?Bc:",
                                      "type": "math_number"
                                    }
                                  },
                                  "ARG5": {
                                    "block": {
                                      "fields": {
                                        "VAR": "Enemy"
                                      },
                                      "id": "somwH|1u,x!HM%,`]l!D",
                                      "type": "teamtag_get"
                                    }
                                  },
                                  "ARG6": {
                                    "block": {
                                      "fields": {
                                        "NUM": 1
                                      },
                                      "id": "yKQ%^,xK,qE=8!GAvlLF",
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
                                "id": "oH]qKN-#qaM$IUqdOA-b",
                                "inputs": {
                                  "A": {
                                    "block": {
                                      "id": "#893HB6u:yzfrDR%7X0X",
                                      "inputs": {
                                        "DIVIDEND": {
                                          "block": {
                                            "fields": {
                                              "OP": "MINUS"
                                            },
                                            "id": "rKr3`d2_7T=(qyQhngDy",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "fields": {
                                                    "THIS": false,
                                                    "VAR": "boardVariable:Tick"
                                                  },
                                                  "id": "cz[LOdg`E3g9@iLB5)/0",
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
                                                      "id": "1_d:cLOn9Hs@h3RdE/[H"
                                                    }
                                                  },
                                                  "id": "@T;x/M4-h^qEFetF7Y])",
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
                                              "NUM": 240
                                            },
                                            "id": ".@O5x9d1Gi;*RX{hS-c;",
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
                                        "NUM": 80
                                      },
                                      "id": "1%fl`x7q?eVCYfc*9c~/",
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
                              "id": "Fj:|W,mVv|NaLX%bOLH0",
                              "inputs": {
                                "DO0": {
                                  "block": {
                                    "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                    "fields": {
                                      "NAME": "boardMethod:AddUnit",
                                      "THIS": true
                                    },
                                    "id": "-y?hX|F.oa:^[W$HQ!lZ",
                                    "inputs": {
                                      "ARG0": {
                                        "block": {
                                          "extraState": "<mutation></mutation>",
                                          "fields": {
                                            "TYPE": "board",
                                            "VAR": {
                                              "id": "5GuWIK=^j,64v?0*.w6K"
                                            }
                                          },
                                          "id": "e.l/7Vh`AvuQ$}4:DWgM",
                                          "type": "variables_get"
                                        }
                                      },
                                      "ARG1": {
                                        "block": {
                                          "fields": {
                                            "VAR": "Location/SPAWNAREA_MOB_001"
                                          },
                                          "id": "b%?y=w=FxW={ug_f[aKy",
                                          "type": "stringkeys_get"
                                        }
                                      },
                                      "ARG4": {
                                        "block": {
                                          "fields": {
                                            "NUM": 0
                                          },
                                          "id": "W%pikQv~1UT@||8E2fE^",
                                          "type": "math_number"
                                        }
                                      },
                                      "ARG5": {
                                        "block": {
                                          "fields": {
                                            "VAR": "Enemy"
                                          },
                                          "id": "0lOG_qJ%Eg]w?:/V4tTG",
                                          "type": "teamtag_get"
                                        }
                                      },
                                      "ARG6": {
                                        "block": {
                                          "fields": {
                                            "NUM": 1
                                          },
                                          "id": "/ormjIq$QtiGmLKwT(yd",
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
                                    "id": "PU{2Bo:f$|idRn`[rj3.",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "id": "q?-ar}pN,-ykVPpm-VcF",
                                          "inputs": {
                                            "DIVIDEND": {
                                              "block": {
                                                "fields": {
                                                  "OP": "MINUS"
                                                },
                                                "id": "fhHYTzO|YEs+)exPtElX",
                                                "inputs": {
                                                  "A": {
                                                    "block": {
                                                      "fields": {
                                                        "THIS": false,
                                                        "VAR": "boardVariable:Tick"
                                                      },
                                                      "id": "R*VP16uh}#j#H1Kb/qca",
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
                                                          "id": "1_d:cLOn9Hs@h3RdE/[H"
                                                        }
                                                      },
                                                      "id": "/!X9MXwoF=sn6}U$q.;G",
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
                                                  "NUM": 240
                                                },
                                                "id": "O=b{WsN5+pxOKZS@~Fw(",
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
                                            "NUM": 160
                                          },
                                          "id": "X4u!gQDEy$%e;}Hl}aur",
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
                  "type": "debug"
                }
              },
              "IF0": {
                "block": {
                  "fields": {
                    "OP": "AND"
                  },
                  "id": "NOZf#D,[dS-2b1OypAq=",
                  "inputs": {
                    "A": {
                      "block": {
                        "fields": {
                          "OP": "EQ"
                        },
                        "id": "p6ZinyLl:q@yoR8~+oQ-",
                        "inputs": {
                          "A": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": "{3f{M(~=@{l{G2v$+EpC"
                                }
                              },
                              "id": "n~m6r+p_cM0xMT1,T?$t",
                              "type": "variables_get"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "NUM": 4
                              },
                              "id": "Ger_;q?V,7@/xk@:wGLf",
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
                        "id": "%%uCdDsfUO[#9-iwUh.2",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "OP": "MINUS"
                              },
                              "id": "CNSwCY%9xwcda(H`6hIg",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "THIS": false,
                                      "VAR": "boardVariable:Tick"
                                    },
                                    "id": "cZmnl7d`b(Xub]%4m4(s",
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
                                        "id": "1_d:cLOn9Hs@h3RdE/[H"
                                      }
                                    },
                                    "id": "u9;2VWB,|(Ii^W`w[@*D",
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
                                "NUM": 479
                              },
                              "id": "uCSIWr|5h#~,T8PuD;8s",
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
        "x": 725,
        "y": 965
      },
      {
        "id": "Pqa=p1p)o9Qd=Y=o|n6~",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "NAME": "Log"
              },
              "id": ".q=,X67!0VQg(CVO{H-i",
              "inputs": {
                "TEXT": {
                  "block": {
                    "fields": {
                      "TEXT": "Battle_01_03"
                    },
                    "id": "@5H@gx;f5hS/lYB@Xfna",
                    "type": "text"
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
                  "id": "~tqyVNjOoFo/STSxOlon",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "NUM": 3
                        },
                        "id": "#ZYJNUZZDz|kP!MLXN7{",
                        "type": "math_number"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "fields": {
                        "TYPE": "board",
                        "VAR": {
                          "id": "1_d:cLOn9Hs@h3RdE/[H"
                        }
                      },
                      "id": "T=]IuW];iI+k=O5Mr7G1",
                      "inputs": {
                        "VALUE": {
                          "block": {
                            "fields": {
                              "THIS": false,
                              "VAR": "boardVariable:Tick"
                            },
                            "id": "9~vB.B2E~8g,nbWhiLp.",
                            "type": "variables_get_reserved"
                          }
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
              "id": "dh/~X@/l~B#D2,WVUnj9",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "+#Re4vQv#m2il-c3YD~K",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "{3f{M(~=@{l{G2v$+EpC"
                            }
                          },
                          "id": "E4Je~/,LUfj~cwZNDiVw",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 2
                          },
                          "id": "-q0ZV-/@Xq`n[AW#vX,{",
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
                      "OP": "GTE"
                    },
                    "id": "{t2-RX?gD}?U8X36K:(c",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "t?[r.|z:ozpeAZh@Hry5",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "THIS": false,
                                  "VAR": "boardVariable:Tick"
                                },
                                "id": "OE]3Fy2zxqdFk9]OxJit",
                                "type": "variables_get_reserved"
                              },
                              "shadow": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "Du/g=xYTGK6NDy%;|?`!",
                                "type": "math_number"
                              }
                            },
                            "B": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "board",
                                  "VAR": {
                                    "id": "1_d:cLOn9Hs@h3RdE/[H"
                                  }
                                },
                                "id": "~e~y=n8(CqHYc#e-uQ)y",
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
                            "NUM": 480
                          },
                          "id": "Vzx}G%C89h{h`(j?[CFM",
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
            "id": "XyCbsH.`0O,qa3Yo%2|a",
            "inputs": {
              "DO0": {
                "block": {
                  "fields": {
                    "NAME": "Log"
                  },
                  "id": ";@2@bZ5E(XWQ1x1(ZqwA",
                  "inputs": {
                    "TEXT": {
                      "block": {
                        "fields": {
                          "TEXT": "Battle_01_03 spawn!"
                        },
                        "id": "-5$@f4X2;1D~J-4`s.y)",
                        "type": "text"
                      }
                    },
                    "VAR": {
                      "block": {
                        "extraState": "<mutation></mutation>",
                        "fields": {
                          "TYPE": "board",
                          "VAR": {
                            "id": "1_d:cLOn9Hs@h3RdE/[H"
                          }
                        },
                        "id": ".s28[hb#[p5}[u_qIFRO",
                        "type": "variables_get"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "id": "n{`X`Ex,uiW#[ad~IPY@",
                      "inputs": {
                        "DO0": {
                          "block": {
                            "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                            "fields": {
                              "NAME": "boardMethod:AddUnit",
                              "THIS": true
                            },
                            "id": "FiT):SZbA6Y-Z#3uID_n",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "extraState": "<mutation></mutation>",
                                  "fields": {
                                    "TYPE": "board",
                                    "VAR": {
                                      "id": "$55Hrhz;D)ycu^x7(ktj"
                                    }
                                  },
                                  "id": ":tr%P%O8=.yYsgQX]p$b",
                                  "type": "variables_get"
                                }
                              },
                              "ARG1": {
                                "block": {
                                  "fields": {
                                    "VAR": "Location/SPAWNAREA_MOB_001"
                                  },
                                  "id": "*q2m`J5{U-UO8owEqGw.",
                                  "type": "stringkeys_get"
                                }
                              },
                              "ARG4": {
                                "block": {
                                  "fields": {
                                    "NUM": 0
                                  },
                                  "id": "w?c/z59Zi!mm#iL,77B0",
                                  "type": "math_number"
                                }
                              },
                              "ARG5": {
                                "block": {
                                  "fields": {
                                    "VAR": "Enemy"
                                  },
                                  "id": "w-{v[7u$^~_l?#pidh%-",
                                  "type": "teamtag_get"
                                }
                              },
                              "ARG6": {
                                "block": {
                                  "fields": {
                                    "NUM": 1
                                  },
                                  "id": "_}1DKi_Rvh]kEe`HXyyl",
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
                            "id": "@m57k|o]+b@I0QL%5%d{",
                            "inputs": {
                              "A": {
                                "block": {
                                  "id": "S|fQPO8^?^c)*e|-sZL?",
                                  "inputs": {
                                    "DIVIDEND": {
                                      "block": {
                                        "fields": {
                                          "OP": "MINUS"
                                        },
                                        "id": "Xn}Sdc.B+;Q2F~T/!)9S",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "THIS": false,
                                                "VAR": "boardVariable:Tick"
                                              },
                                              "id": "BXp?K,ppz+P*Q9O.d|T+",
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
                                                  "id": "1_d:cLOn9Hs@h3RdE/[H"
                                                }
                                              },
                                              "id": "3n!{V$/hmy7~*6;}deF4",
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
                                          "NUM": 240
                                        },
                                        "id": "H{2n0)B-%@Y_^GrqnMo7",
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
                                  "id": "j:NPX4Xr8Ii7hxCh%lpa",
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
                          "id": "`(*pL.Q=dV8VLYA6KH%#",
                          "inputs": {
                            "DO0": {
                              "block": {
                                "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                "fields": {
                                  "NAME": "boardMethod:AddUnit",
                                  "THIS": true
                                },
                                "id": "U~)y.!r);G#9E[+;CnLM",
                                "inputs": {
                                  "ARG0": {
                                    "block": {
                                      "extraState": "<mutation></mutation>",
                                      "fields": {
                                        "TYPE": "board",
                                        "VAR": {
                                          "id": ",bT)653^%NmWNmc9-E,j"
                                        }
                                      },
                                      "id": "ifZ:KN;]CZv~AxjI5AS=",
                                      "type": "variables_get"
                                    }
                                  },
                                  "ARG1": {
                                    "block": {
                                      "fields": {
                                        "VAR": "Location/SPAWNAREA_MOB_001"
                                      },
                                      "id": "KH2D+r~i#qo~MfEzL/xr",
                                      "type": "stringkeys_get"
                                    }
                                  },
                                  "ARG4": {
                                    "block": {
                                      "fields": {
                                        "NUM": 0
                                      },
                                      "id": "Vb7Q-h*=Md@W9gqQr8H-",
                                      "type": "math_number"
                                    }
                                  },
                                  "ARG5": {
                                    "block": {
                                      "fields": {
                                        "VAR": "Enemy"
                                      },
                                      "id": "?Bg7GO,r~EKX(95?g:v{",
                                      "type": "teamtag_get"
                                    }
                                  },
                                  "ARG6": {
                                    "block": {
                                      "fields": {
                                        "NUM": 1
                                      },
                                      "id": "15Qw]=6Nr)F]#LMsc$G|",
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
                                "id": "Sv#/3D]ZxX,TSh.C]DC$",
                                "inputs": {
                                  "A": {
                                    "block": {
                                      "id": "I^n=UKs7-PA$ap37|pvD",
                                      "inputs": {
                                        "DIVIDEND": {
                                          "block": {
                                            "fields": {
                                              "OP": "MINUS"
                                            },
                                            "id": "8VnTlQz9G)qAX:`v$@-,",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "fields": {
                                                    "THIS": false,
                                                    "VAR": "boardVariable:Tick"
                                                  },
                                                  "id": "lVPH_Sh+g}3r1pw_NjS3",
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
                                                      "id": "1_d:cLOn9Hs@h3RdE/[H"
                                                    }
                                                  },
                                                  "id": "{aFt*XLsoBF=M3rH:rJj",
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
                                              "NUM": 240
                                            },
                                            "id": "!J$FchG6G8;|76HsWPHU",
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
                                      "id": "zP9!jluC#%wwy7CJKQK5",
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
                  "type": "debug"
                }
              },
              "IF0": {
                "block": {
                  "fields": {
                    "OP": "AND"
                  },
                  "id": "|lLdjAQ]-tM4BQ:z,Sr9",
                  "inputs": {
                    "A": {
                      "block": {
                        "fields": {
                          "OP": "EQ"
                        },
                        "id": "[c^,$mr#:BVmaMf.*Y=;",
                        "inputs": {
                          "A": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": "{3f{M(~=@{l{G2v$+EpC"
                                }
                              },
                              "id": "^~YdVB6$4:k;dDa+DM5F",
                              "type": "variables_get"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "NUM": 3
                              },
                              "id": "9}@4|IO:(Is3rJ(!t:65",
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
                        "id": "2r~#eZ?KkQez;wm9mPI1",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "OP": "MINUS"
                              },
                              "id": "Pk$dL{gd-fO9?]S4qycj",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "THIS": false,
                                      "VAR": "boardVariable:Tick"
                                    },
                                    "id": "AYkKJvC8Wo)*H?=bl^]#",
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
                                        "id": "1_d:cLOn9Hs@h3RdE/[H"
                                      }
                                    },
                                    "id": "G_m5HXeo?OZHyd5iq.^p",
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
                                "NUM": 479
                              },
                              "id": ".hSC.IBH/`KQafrpRQUG",
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
        "x": 725,
        "y": -55
      },
      {
        "fields": {
          "NAME": "Log"
        },
        "id": "H}$iT/ATEC{;F:_YG6xO",
        "inputs": {
          "TEXT": {
            "block": {
              "fields": {
                "TEXT": "현재 적 유닛수"
              },
              "id": "DlT/^[/e$Y.JnKt6L#tC",
              "type": "text"
            }
          },
          "VAR": {
            "block": {
              "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Team (필수)&quot;,&quot;name&quot;:&quot;Team&quot;}]\"></mutation>",
              "fields": {
                "NAME": "boardMethod:GetUnitCountByTeam",
                "THIS": false
              },
              "id": "Xj.04]@C`g12}R:RZ7HN",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "VAR": "Enemy"
                    },
                    "id": "QkPy#I(pA8Qh?J)yb5S^",
                    "type": "teamtag_get"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "next": {
          "block": {
            "fields": {
              "NAME": "Log"
            },
            "id": "WUz+Zbl@jL+iFCnMMm;n",
            "inputs": {
              "TEXT": {
                "block": {
                  "fields": {
                    "TEXT": "현재 이동 거리 Check"
                  },
                  "id": "+E.fr8lT-MRA,B0GjOa6",
                  "type": "text"
                }
              },
              "VAR": {
                "block": {
                  "fields": {
                    "OP": "MINUS"
                  },
                  "id": "afrQ!)z0OTRS^GInGV@~",
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
                        "id": "aAKv8CSY$wWMCQ,DSt%L",
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
                        "id": "sGUir$s`clg`k#1q.y[5",
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
            "type": "debug"
          }
        },
        "type": "debug",
        "x": 755,
        "y": -2705
      },
      {
        "fields": {
          "NAME": "MAP_ONUPDATE_TUTORIAL_WAVE2",
          "THIS": true
        },
        "id": "U)a;=BEs#,=l(htM#nfX",
        "next": {
          "block": {
            "fields": {
              "NAME": "MAP_ONUPDATE_TUTORIAL_WAVE3",
              "THIS": true
            },
            "id": "%TT=(uk3raQQ%$),RBk.",
            "next": {
              "block": {
                "fields": {
                  "NAME": "MAP_ONUPDATE_TUTORIAL_WAVE4",
                  "THIS": true
                },
                "id": "H*GLbiA)tsCu.WDTL/C|",
                "type": "trigger_call"
              }
            },
            "type": "trigger_call"
          }
        },
        "type": "trigger_call",
        "x": 765,
        "y": -3095
      },
      {
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
                  "id": "`5pNm2`l77gz.*4~3]!Q",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "NUM": 0
                        },
                        "id": ":x`sb1f+ma0W^mKao8@x",
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
                              "id": "ExrI[$k~3:=~FB=Lr:]?"
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
        "x": 755,
        "y": -2895
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
                            "TEXT": "Battle_01_01"
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
                            "id": "1_d:cLOn9Hs@h3RdE/[H"
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
                                "id": "Kt0d8[KF}%U!t*GDGv`w"
                              }
                            },
                            "id": ":2IR0iG)@Aq_#L16)M=O",
                            "inputs": {
                              "VALUE": {
                                "block": {
                                  "fields": {
                                    "THIS": false,
                                    "VAR": "boardVariable:Tick"
                                  },
                                  "id": "XD63*)TDM.*P,d,OU.]^",
                                  "type": "variables_get_reserved"
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
                                "id": "H|`37_Me+Ticr6smO)|{",
                                "inputs": {
                                  "VALUE": {
                                    "block": {
                                      "fields": {
                                        "NUM": 1
                                      },
                                      "id": "{Ede%Rxpsz.U/z$S^H$I",
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
                                            "id": "V3!I#9ZxGNJUFfqc$Uyk"
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
                              "id": "{3f{M(~=@{l{G2v$+EpC"
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
                      "OP": "LTE"
                    },
                    "id": "E~.?CD;pQ9KstDJ$!}_~",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "NUM": 0.5
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
                    "id": "u6}R?gOxHd%DJpj6WZ7V",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "V3!I#9ZxGNJUFfqc$Uyk"
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
        "x": 765,
        "y": -2485
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
                        "id": "V3!I#9ZxGNJUFfqc$Uyk"
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
        "x": 765,
        "y": -2045
      },
      {
        "id": "?$SG~nC*mRXyEE}2/F|C",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "NAME": "Log"
              },
              "id": "-#iFJM+5L!=KZ]0y-$=L",
              "inputs": {
                "TEXT": {
                  "block": {
                    "fields": {
                      "TEXT": "Battle_01_01 spawn!"
                    },
                    "id": "I(QgjW^%}/XXnV^lgc=m",
                    "type": "text"
                  }
                },
                "VAR": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "board",
                      "VAR": {
                        "id": "1_d:cLOn9Hs@h3RdE/[H"
                      }
                    },
                    "id": "?n[sMF3ST,v]FuE^Hyub",
                    "type": "variables_get"
                  }
                }
              },
              "next": {
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
                        "id": "m)_@%.DfH0Y-%;p_[,O#",
                        "inputs": {
                          "ARG0": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": "$55Hrhz;D)ycu^x7(ktj"
                                }
                              },
                              "id": "sG=F6co8*7sDlo=:+]eh",
                              "type": "variables_get"
                            }
                          },
                          "ARG1": {
                            "block": {
                              "fields": {
                                "VAR": "Location/SPAWNAREA_MOB_001"
                              },
                              "id": "kHlp+M6JhSWBpWDG|@$}",
                              "type": "stringkeys_get"
                            }
                          },
                          "ARG4": {
                            "block": {
                              "fields": {
                                "NUM": 0
                              },
                              "id": "Fs=%q:~DIW^2G4_`lGO{",
                              "type": "math_number"
                            }
                          },
                          "ARG5": {
                            "block": {
                              "fields": {
                                "VAR": "Enemy"
                              },
                              "id": "N^j*[=X,B,MZ^|~H]IE4",
                              "type": "teamtag_get"
                            }
                          },
                          "ARG6": {
                            "block": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "qSgbTt@UgHWs;FbBNA+U",
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
                                              "id": "1_d:cLOn9Hs@h3RdE/[H"
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
                                      "NUM": 240
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
                  "next": {
                    "block": {
                      "id": "@azOTQnZf9c=6v]3wiFQ",
                      "inputs": {
                        "DO0": {
                          "block": {
                            "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                            "fields": {
                              "NAME": "boardMethod:AddUnit",
                              "THIS": true
                            },
                            "id": "NR|.a#3(By^p2YJD6^lP",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "extraState": "<mutation></mutation>",
                                  "fields": {
                                    "TYPE": "board",
                                    "VAR": {
                                      "id": "$55Hrhz;D)ycu^x7(ktj"
                                    }
                                  },
                                  "id": "WvK;^WCVG0yO2m5f/r+H",
                                  "type": "variables_get"
                                }
                              },
                              "ARG1": {
                                "block": {
                                  "fields": {
                                    "VAR": "Location/SPAWNAREA_MOB_001"
                                  },
                                  "id": "xvmIp92|h/m5S9$h0W}Y",
                                  "type": "stringkeys_get"
                                }
                              },
                              "ARG4": {
                                "block": {
                                  "fields": {
                                    "NUM": 0
                                  },
                                  "id": "pk9kI])6%vz+li3MYE_i",
                                  "type": "math_number"
                                }
                              },
                              "ARG5": {
                                "block": {
                                  "fields": {
                                    "VAR": "Enemy"
                                  },
                                  "id": "6:tF/+J5~px(-1R)^A,R",
                                  "type": "teamtag_get"
                                }
                              },
                              "ARG6": {
                                "block": {
                                  "fields": {
                                    "NUM": 1
                                  },
                                  "id": "aV2@1@#DgvcG!,_Bx,5Y",
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
                            "id": "fdu{yHG*ijDD)HdUf}Hz",
                            "inputs": {
                              "A": {
                                "block": {
                                  "id": "8c6Whc|#?aW)S3=07(ii",
                                  "inputs": {
                                    "DIVIDEND": {
                                      "block": {
                                        "fields": {
                                          "OP": "MINUS"
                                        },
                                        "id": "}n}=sb_!w,_ZZMV?jGE(",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "THIS": false,
                                                "VAR": "boardVariable:Tick"
                                              },
                                              "id": ":2Bd1S)ehPa}rTrEs/Md",
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
                                                  "id": "1_d:cLOn9Hs@h3RdE/[H"
                                                }
                                              },
                                              "id": "f*a_cVXE(V[/K=;ZB,s]",
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
                                          "NUM": 240
                                        },
                                        "id": "MP1y.Prj@^}aD^JXCQlM",
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
                                  "id": "cbP@9mR(Q^w7q:GV$.(w",
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
              "type": "debug"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "AND"
              },
              "id": "~2a@uIY0ocUZDFSp2C|-",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": ",=;6;~BM,cd%tbM$w]mU",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "{3f{M(~=@{l{G2v$+EpC"
                            }
                          },
                          "id": "dFlN}pmKjcqv_VF-z7v3",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "OR9n0skC2PIIqUg[m(tv",
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
                    "id": "M(X!a;yZZF~gWf}~lH+B",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "a/J$|VR;Ry+xk{G{KM07",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "THIS": false,
                                  "VAR": "boardVariable:Tick"
                                },
                                "id": "^8n:wW75J)_CnC.Rhq2O",
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
                                    "id": "1_d:cLOn9Hs@h3RdE/[H"
                                  }
                                },
                                "id": "Q++FF{VKspTgo|`{%vp+",
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
                            "NUM": 479
                          },
                          "id": "YSI%%Q@wr#RidZ_nx;Y[",
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
        "x": 755,
        "y": -1925
      },
      {
        "id": "R[UxIy/U:aMS0G4E(RAJ",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "NAME": "Log"
              },
              "id": "]^!4n2:`f$i/ON[2HeIQ",
              "inputs": {
                "TEXT": {
                  "block": {
                    "fields": {
                      "TEXT": "Battle_01_02"
                    },
                    "id": "iol1;Stw^3^_NlnwEX3_",
                    "type": "text"
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
                  "id": "kG2a}1_xzY_/;_WXqN!9",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "NUM": 2
                        },
                        "id": "Q|1LAfT`G/]M{Dc9+2][",
                        "type": "math_number"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "fields": {
                        "TYPE": "board",
                        "VAR": {
                          "id": "1_d:cLOn9Hs@h3RdE/[H"
                        }
                      },
                      "id": "tvqvr.#oCysw2H}V%0#%",
                      "inputs": {
                        "VALUE": {
                          "block": {
                            "fields": {
                              "THIS": false,
                              "VAR": "boardVariable:Tick"
                            },
                            "id": "7PHJe8LjoJtznf410.1)",
                            "type": "variables_get_reserved"
                          }
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
              "id": "9GHSvK1oX-oMkz{uc[Y+",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "]VVJ.X`n2Z6B1::.Rv4#",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "{3f{M(~=@{l{G2v$+EpC"
                            }
                          },
                          "id": "U-qpWl`AAok||2?edhnn",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "[BETm={0z}*cZ1;b2b@Q",
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
                      "OP": "GTE"
                    },
                    "id": "rn+=p[stt=xW?B{j2?0?",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "3t8P!o68`r5X@A;xSrL0",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "THIS": false,
                                  "VAR": "boardVariable:Tick"
                                },
                                "id": "%xD)13oY:Z](**`Mc60T",
                                "type": "variables_get_reserved"
                              },
                              "shadow": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "s0eP/[0tkdYq1[(wVUTc",
                                "type": "math_number"
                              }
                            },
                            "B": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "board",
                                  "VAR": {
                                    "id": "1_d:cLOn9Hs@h3RdE/[H"
                                  }
                                },
                                "id": "mD~RafiOd]g/DL}O1lo$",
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
                            "NUM": 480
                          },
                          "id": "`p(31oR~Vg5*|bO3;Q!?",
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
            "id": "hg#H/Y%||hLeg*mt@d)k",
            "inputs": {
              "DO0": {
                "block": {
                  "fields": {
                    "NAME": "Log"
                  },
                  "id": "v[=~c;j;8y77LCD`_P{R",
                  "inputs": {
                    "TEXT": {
                      "block": {
                        "fields": {
                          "TEXT": "Battle_01_02 spawn!"
                        },
                        "id": "h3_60#(5mFKk`p:40GVF",
                        "type": "text"
                      }
                    },
                    "VAR": {
                      "block": {
                        "extraState": "<mutation></mutation>",
                        "fields": {
                          "TYPE": "board",
                          "VAR": {
                            "id": "1_d:cLOn9Hs@h3RdE/[H"
                          }
                        },
                        "id": "X$UN(3r~mM6eoV0pu}hO",
                        "type": "variables_get"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "id": "uZoBFo6nd]cUnm3T4$h+",
                      "inputs": {
                        "DO0": {
                          "block": {
                            "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                            "fields": {
                              "NAME": "boardMethod:AddUnit",
                              "THIS": true
                            },
                            "id": "Nv?C$}?6C{k^q2@#g-*A",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "extraState": "<mutation></mutation>",
                                  "fields": {
                                    "TYPE": "board",
                                    "VAR": {
                                      "id": "$55Hrhz;D)ycu^x7(ktj"
                                    }
                                  },
                                  "id": "wY.HFvq]rRGP.5od*(nc",
                                  "type": "variables_get"
                                }
                              },
                              "ARG1": {
                                "block": {
                                  "fields": {
                                    "VAR": "Location/SPAWNAREA_MOB_001"
                                  },
                                  "id": "SSnLyF6z4|}=]hj5g,CJ",
                                  "type": "stringkeys_get"
                                }
                              },
                              "ARG4": {
                                "block": {
                                  "fields": {
                                    "NUM": 0
                                  },
                                  "id": "W;kdUyPQuJ-y)~)aKchA",
                                  "type": "math_number"
                                }
                              },
                              "ARG5": {
                                "block": {
                                  "fields": {
                                    "VAR": "Enemy"
                                  },
                                  "id": "j/?tu/!xwpK;@uWyW,v2",
                                  "type": "teamtag_get"
                                }
                              },
                              "ARG6": {
                                "block": {
                                  "fields": {
                                    "NUM": 1
                                  },
                                  "id": "3V^x.1~Ddp^)#JS7cO]n",
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
                            "id": "MH_9OypbmZ/^B2GRiW/R",
                            "inputs": {
                              "A": {
                                "block": {
                                  "id": "VoM2UzIGS)erA6$r)Q{N",
                                  "inputs": {
                                    "DIVIDEND": {
                                      "block": {
                                        "fields": {
                                          "OP": "MINUS"
                                        },
                                        "id": "ejiv!(^xBa#Rnz|G*jf6",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "THIS": false,
                                                "VAR": "boardVariable:Tick"
                                              },
                                              "id": "JS;;^cd]`:0D5;lJMp6e",
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
                                                  "id": "1_d:cLOn9Hs@h3RdE/[H"
                                                }
                                              },
                                              "id": "xg}E)-Y=zTykQGc]WX=1",
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
                                          "NUM": 240
                                        },
                                        "id": ":#GyX$D*sKQ.}ZYs`|CH",
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
                                  "id": "?@FB^$*vC2c}*q#gRtYG",
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
                          "id": "}sa2`MVEo]8F1PW)t+N~",
                          "inputs": {
                            "DO0": {
                              "block": {
                                "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                "fields": {
                                  "NAME": "boardMethod:AddUnit",
                                  "THIS": true
                                },
                                "id": "~gz8V.c7_I2NRtXs.%.E",
                                "inputs": {
                                  "ARG0": {
                                    "block": {
                                      "extraState": "<mutation></mutation>",
                                      "fields": {
                                        "TYPE": "board",
                                        "VAR": {
                                          "id": "%=P6Pw5JP:;nkVC8s|1~"
                                        }
                                      },
                                      "id": "XK4K9Ssf`.kq`6i4#!~S",
                                      "type": "variables_get"
                                    }
                                  },
                                  "ARG1": {
                                    "block": {
                                      "fields": {
                                        "VAR": "Location/SPAWNAREA_MOB_001"
                                      },
                                      "id": "LVF$*%H~cO]zN(N^[2w?",
                                      "type": "stringkeys_get"
                                    }
                                  },
                                  "ARG4": {
                                    "block": {
                                      "fields": {
                                        "NUM": 0
                                      },
                                      "id": "`pvF*06ZA(v)vS#hH_`t",
                                      "type": "math_number"
                                    }
                                  },
                                  "ARG5": {
                                    "block": {
                                      "fields": {
                                        "VAR": "Enemy"
                                      },
                                      "id": "`/(~J(zDqPy|@|-ZCqM(",
                                      "type": "teamtag_get"
                                    }
                                  },
                                  "ARG6": {
                                    "block": {
                                      "fields": {
                                        "NUM": 1
                                      },
                                      "id": "OCPd2C/T1vEJJdy)x=uW",
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
                                "id": "qWSB=3`V:DQr$@Vp{B29",
                                "inputs": {
                                  "A": {
                                    "block": {
                                      "id": "j^S(6%sdgW!DP7T;!Z5`",
                                      "inputs": {
                                        "DIVIDEND": {
                                          "block": {
                                            "fields": {
                                              "OP": "MINUS"
                                            },
                                            "id": "Fd@t,eLUKpaR!4pHy@br",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "fields": {
                                                    "THIS": false,
                                                    "VAR": "boardVariable:Tick"
                                                  },
                                                  "id": "N*n|3C(@sE8~Ld?oM%~!",
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
                                                      "id": "1_d:cLOn9Hs@h3RdE/[H"
                                                    }
                                                  },
                                                  "id": "uwH|Mc^V=/=8CUxVGb5V",
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
                                              "NUM": 240
                                            },
                                            "id": "5_E]oO-.RMto(EbfI7~.",
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
                                      "id": "3.qh`.!,9.Koi^W#Hf|y",
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
                  "type": "debug"
                }
              },
              "IF0": {
                "block": {
                  "fields": {
                    "OP": "AND"
                  },
                  "id": "#L-Pg_]e?~_~r1YVd,*4",
                  "inputs": {
                    "A": {
                      "block": {
                        "fields": {
                          "OP": "EQ"
                        },
                        "id": "F``_Bc;$/iQcX%n;zL:[",
                        "inputs": {
                          "A": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": "{3f{M(~=@{l{G2v$+EpC"
                                }
                              },
                              "id": "dyV:#[5k.T=Q^/oP}a5)",
                              "type": "variables_get"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "NUM": 2
                              },
                              "id": "i@P7ps9}(8*h.TI%)5en",
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
                        "id": "6*i3I!lYUt(Z]A*E.*gs",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "OP": "MINUS"
                              },
                              "id": "*(,}DKy4kN`%.|$vH%e0",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "THIS": false,
                                      "VAR": "boardVariable:Tick"
                                    },
                                    "id": "|ieai5GvwqzFl2,yFv7o",
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
                                        "id": "1_d:cLOn9Hs@h3RdE/[H"
                                      }
                                    },
                                    "id": "%o$siAGTLvDD*M@7tkXb",
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
                                "NUM": 479
                              },
                              "id": "ne_x4eS*^g:1}^d9f8sv",
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
        "x": 735,
        "y": -1105
      },
      {
        "id": "l=NnBL!b}`w/9T6h~W0*",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "TYPE": "board",
                "VAR": {
                  "id": "QKDIW|rJfw.bv*GNE1lw"
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
                  "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Achievement Data Id (필수)&quot;,&quot;name&quot;:&quot;AchievementDataId&quot;},{&quot;comment&quot;:&quot;Progress (default = 1)&quot;,&quot;name&quot;:&quot;Progress&quot;},{&quot;comment&quot;:&quot;PlayerId (default = 0)&quot;,&quot;name&quot;:&quot;PlayerId&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "boardMethod:IncreaseAchievementProgress",
                    "THIS": false
                  },
                  "id": "kEl@usC|KkiE*6c8N_ln",
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
                        "id": "G;RLB6$wmn#mMAKlMD/J",
                        "type": "variables_get"
                      }
                    },
                    "ARG1": {
                      "block": {
                        "fields": {
                          "NUM": 1
                        },
                        "id": "dD04$5#yZcP/r+ygOc7c",
                        "type": "math_number"
                      }
                    }
                  },
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
              "type": "variables_set"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "EQ"
              },
              "id": "qxf7nb?c*@*R/7G_Z7j3",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "MINUS"
                    },
                    "id": "bDMF-h9)9ygdw0KS@9+4",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "THIS": false,
                            "VAR": "boardVariable:Tick"
                          },
                          "id": "k#eo2Rvk`1a5XG*aQUz2",
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
                              "id": "Kt0d8[KF}%U!t*GDGv`w"
                            }
                          },
                          "id": "iU(G,$G1*//YKr|vV0=D",
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
                      "NUM": 1650
                    },
                    "id": "}7t7*H:SzH~%klF(UfMr",
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
        "y": 2345
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "MAP_ONUPDATE_TUTORIAL_WAVE1",
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
      "id": "1g.{8c;v(tTQ!K,@9uYO",
      "name": "Gem"
    },
    {
      "id": "/Z~j!%8UzeE_07Ocp*M6",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "Vmw[!WtfF/8f.|?l+wft",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "fKc_5*Y;:ZyhOUw|l8YM",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "%r$KWyQYBpd,{/jK;fhH",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": ".2CEA.OGJ!TU)?CV{WPo",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "2b{8}Of_?!~16xScM1_q",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "YU;]F0!XENZTlbNJjP,F",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "GCT,KPIB`Dcwp,X.-~B%",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "9R8G*AV/aFXqwOc_5Je-",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "e6_@qE6b6UvXD$wRyM~f",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "2XkU:~2,!Ms@Zj!+VeBt",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "1![Sz)+_vQkd#Hb((gRC",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "n!#*oV!=xHY#DT||9KjT",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "AVV;=Iz-z5#)!ueVIaSZ",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "RM,wI81Z;!T|bVUL{SD1",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "|QB)TozWJdKJ%!u[S!QI",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "3)}x`_Ot^HBKrHl:$~vJ",
      "name": "@Map/Progress"
    },
    {
      "id": "Oq0;m=WpT]`=RYZn~;X1",
      "name": "Map/Wave"
    },
    {
      "id": "V`{-$]+y@7z@7I8BDxYn",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "_q%C@`%*-}VLqs1=9|(6",
      "name": "Map/Wave/Step"
    },
    {
      "id": "8pk0uzn6XX*]RqC{3Vb}",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "#o/.6LH*8ere(}k8:`|0",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "x;9v@M;c%C:%o~+DdYPA",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "b3!)0sl3M{fi2SS#:m`E",
      "name": "Map/Wave/State"
    },
    {
      "id": "oZDR`(Pa;h8o?%HJ.axh",
      "name": "Map/Player/Moving"
    },
    {
      "id": "26J+$Y@+FHG[*!`R|O?{",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "srhP=iP^Uf;!d)?FvPqu",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "jq6MmN~Iu};wFV,:Co={",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "IpJ=$nyvI`+g]5=8Ib4V",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "Lhl9H1p1zEnCZUdcvPVb",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "#jXMO^(7;%z[@hplqIwL",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "s`Z?7kA]Q,osT+B:t~=t",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "4MvCrM7lh)QH!6ovd8l)",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "~0?.0J@o|%|/7m}$#~T6",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "Sf89GN(}O9t6XBOs|!,S",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "1W!er8#b!O8)I.[!vk((",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "y7HDLfHKm=}bL7!U25X5",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": ")M9kO?QY)pRToX7?nm|n",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "wp7TThoe*EoA1u$?v0:K",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "V{)10e([r2+w]poh2VJU",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": ",%}]aF/ZY.t^n+!@.;Ro",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "CVB}OO,a=7^=N(sk!Jqc",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "qM)PC1qvb-E|d/QZ[`AG",
      "name": "@Map/Player/InitUseSkill3"
    }
  ]
}