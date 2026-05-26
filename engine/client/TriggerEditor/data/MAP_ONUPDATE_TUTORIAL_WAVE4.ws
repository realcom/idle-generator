{
  "blocks": {
    "blocks": [
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
                            "TEXT": "Battle_04_01"
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
                            "NUM": 4
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
                              "id": "{3f{M(~=@{l{G2v$+EpC"
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
        "x": 754,
        "y": -2252
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
        "x": 755,
        "y": -2485
      },
      {
        "id": "03jNBRcnPy3+qvjcDK3v",
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
                                    "id": "QxX0yIG9dXhfz~xvdfCh"
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
              "id": "Q3w~M`$g?q3iuMhEri^x",
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
                    "id": "%b!Zjo1jd`dGsiEJruM7",
                    "type": "variables_get"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "NUM": 4
                    },
                    "id": "|(~x8r[?5Nfjxla{./XD",
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
        "y": 2855
      },
      {
        "id": "nCCqs{CLSqty/Sh0S+CB",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "NAME": "Log"
              },
              "id": "by~e$0D`5N72`^bhU+k}",
              "inputs": {
                "TEXT": {
                  "block": {
                    "fields": {
                      "TEXT": "Battle_03_03 spawn!"
                    },
                    "id": "WiRTiP8fJkAd]|fKZo6.",
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
                    "id": "R+`N`gM3{4o??[#8e}zd",
                    "type": "variables_get"
                  }
                }
              },
              "next": {
                "block": {
                  "id": "_z+VuwPy:V~0Wm]MF]95",
                  "inputs": {
                    "DO0": {
                      "block": {
                        "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                        "fields": {
                          "NAME": "boardMethod:AddUnit",
                          "THIS": true
                        },
                        "id": ")Y`}Giy)2_@7l:uL/-WV",
                        "inputs": {
                          "ARG0": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": "MQFH$O%ql+8,`pg,C!f_"
                                }
                              },
                              "id": "h$b89fYPiE:W6a0^5-,%",
                              "type": "variables_get"
                            }
                          },
                          "ARG1": {
                            "block": {
                              "fields": {
                                "VAR": "Location/SPAWNAREA_MOB_004"
                              },
                              "id": "`op_@*/=m)WXvL#q/,F{",
                              "type": "stringkeys_get"
                            }
                          },
                          "ARG4": {
                            "block": {
                              "fields": {
                                "NUM": 0
                              },
                              "id": "]+Choc|Y^cYO?PQ`Km?%",
                              "type": "math_number"
                            }
                          },
                          "ARG5": {
                            "block": {
                              "fields": {
                                "VAR": "Enemy"
                              },
                              "id": "(F^)zcb^]]+RL6Z6tss/",
                              "type": "teamtag_get"
                            }
                          },
                          "ARG6": {
                            "block": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "Ih:E`h_fR-m^g5IGLi^R",
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
                        "id": "#5KX;d)M[c-JgKE7=uK)",
                        "inputs": {
                          "A": {
                            "block": {
                              "id": "V/+TF#,!qjJ@BuJBN#Ob",
                              "inputs": {
                                "DIVIDEND": {
                                  "block": {
                                    "fields": {
                                      "OP": "MINUS"
                                    },
                                    "id": "U$wqulE9q2(iwDpwLPK_",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "fields": {
                                            "THIS": false,
                                            "VAR": "boardVariable:Tick"
                                          },
                                          "id": "1Mo[K:/-RT4Vwu@ZpBbj",
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
                                          "id": "uDso0^-.CdD0Oyg-[4jb",
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
                                    "id": "zyZ59LFG9k]W(37@(M/g",
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
                              "id": "Wj^)`PY0)6sa2fHsD5/X",
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
                      "id": "TiC6ccWFIZVQKbX4{~1;",
                      "inputs": {
                        "DO0": {
                          "block": {
                            "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                            "fields": {
                              "NAME": "boardMethod:AddUnit",
                              "THIS": true
                            },
                            "id": "HPz903A*EEbhHF6+`F+C",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "extraState": "<mutation></mutation>",
                                  "fields": {
                                    "TYPE": "board",
                                    "VAR": {
                                      "id": ",z?-{}Oa.puv7PUu9FZo"
                                    }
                                  },
                                  "id": "*W7b-c;XPB+v|E.J~Pl?",
                                  "type": "variables_get"
                                }
                              },
                              "ARG1": {
                                "block": {
                                  "fields": {
                                    "VAR": "Location/SPAWNAREA_MOB_004"
                                  },
                                  "id": "j`01sFuiy(t,vmX%F4.O",
                                  "type": "stringkeys_get"
                                }
                              },
                              "ARG4": {
                                "block": {
                                  "fields": {
                                    "NUM": 0
                                  },
                                  "id": "^~tKqwN6]$^?GfB|7Ucr",
                                  "type": "math_number"
                                }
                              },
                              "ARG5": {
                                "block": {
                                  "fields": {
                                    "VAR": "Enemy"
                                  },
                                  "id": "`N^M1;7t%iwh_I=rWZrH",
                                  "type": "teamtag_get"
                                }
                              },
                              "ARG6": {
                                "block": {
                                  "fields": {
                                    "NUM": 1
                                  },
                                  "id": "LX~uJ+4IpOiIJ$1;gL=X",
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
                            "id": "5(:b_eO#I:qUK.HDUFp{",
                            "inputs": {
                              "A": {
                                "block": {
                                  "id": "%w%%4-P?LB@6H?:df[rq",
                                  "inputs": {
                                    "DIVIDEND": {
                                      "block": {
                                        "fields": {
                                          "OP": "MINUS"
                                        },
                                        "id": "A}x6glTG|0.i%7M)a-yF",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "THIS": false,
                                                "VAR": "boardVariable:Tick"
                                              },
                                              "id": "EIaB;6Nx3[E*;uKawED=",
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
                                              "id": "c%~$%}(5EU~;Ys#hTGK.",
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
                                        "id": ",elZalmUb`g+[m1$d(I`",
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
                                  "id": "gvHH`-}Ro)i|__[w{WpX",
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
              "id": "fbKKwdPn[fJT@KTZR((E",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "q*LK:G2Li*(ZK?Rh}cgl",
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
                          "id": "jIE5MV{O-{QS!,HhbTM;",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": ")R`[oMnF[8S[:;|HWe]z",
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
                    "id": "jbu1Z2[SaAQi)`stnY:1",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "dF]kOB$Lt|C?.oe!Jn{G",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "THIS": false,
                                  "VAR": "boardVariable:Tick"
                                },
                                "id": "YiCR8j%JcqhHdX3_x4|c",
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
                                "id": "(1d`$%|ASb#B2+sFn~;b",
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
                          "id": ",8DwEGEJODeSD)[CU19E",
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
                          "TEXT": "Battle_04_02"
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
                      "id": ";|zDZF[6UFWM+AAe;gn5",
                      "inputs": {
                        "DELTA": {
                          "shadow": {
                            "fields": {
                              "NUM": 1
                            },
                            "id": "[ci?[9c6o20g~=_i5q8h",
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
                      "type": "math_change"
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
            "type": "controls_if"
          }
        },
        "type": "controls_if",
        "x": 715,
        "y": -1785
      },
      {
        "id": "3i%2fG|1173vY#apG$UF",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "NAME": "Log"
              },
              "id": "/=B[[Ce}nWGow+EAi|W5",
              "inputs": {
                "TEXT": {
                  "block": {
                    "fields": {
                      "TEXT": "Battle_04_02 spawn!"
                    },
                    "id": "/:lQiPYKUtk26a}V}kQ7",
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
                    "id": "q14^czS{ujp)CeB!Nxr%",
                    "type": "variables_get"
                  }
                }
              },
              "next": {
                "block": {
                  "id": "F2/ycwR[;+/4N[sZyhuy",
                  "inputs": {
                    "DO0": {
                      "block": {
                        "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                        "fields": {
                          "NAME": "boardMethod:AddUnit",
                          "THIS": true
                        },
                        "id": "k;![0CPN^[M|]X,.WkX$",
                        "inputs": {
                          "ARG0": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": "MQFH$O%ql+8,`pg,C!f_"
                                }
                              },
                              "id": "vbKws_mwt9ETdIZu-+??",
                              "type": "variables_get"
                            }
                          },
                          "ARG1": {
                            "block": {
                              "fields": {
                                "VAR": "Location/SPAWNAREA_MOB_004"
                              },
                              "id": "K#WWNqs/.]@.jfcSU{,h",
                              "type": "stringkeys_get"
                            }
                          },
                          "ARG4": {
                            "block": {
                              "fields": {
                                "NUM": 0
                              },
                              "id": "m0C/D(U`[o.$J/PvdyLx",
                              "type": "math_number"
                            }
                          },
                          "ARG5": {
                            "block": {
                              "fields": {
                                "VAR": "Enemy"
                              },
                              "id": "+RIyHu!f@y/V6I|?H%nf",
                              "type": "teamtag_get"
                            }
                          },
                          "ARG6": {
                            "block": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "MK8iH],L^P!,SY6fJ_JM",
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
                        "id": "PdGcFkH-%G)557AjLQJ$",
                        "inputs": {
                          "A": {
                            "block": {
                              "id": "O{;yI5tQJ.MJr3P0fe+N",
                              "inputs": {
                                "DIVIDEND": {
                                  "block": {
                                    "fields": {
                                      "OP": "MINUS"
                                    },
                                    "id": "jTI0m-dbO]k$BrQxAI0@",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "fields": {
                                            "THIS": false,
                                            "VAR": "boardVariable:Tick"
                                          },
                                          "id": ",Ln{Wj~srtx7u?rtB,bW",
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
                                          "id": ":qm{_#~(P{jwIL2[zi(I",
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
                                    "id": "8GpJ;@t0Mdl*YY;:7Ki;",
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
                              "id": ";%wc%c]KMGxFg7ij5]_F",
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
                      "id": "O_]R9A`m)T#5*-Q@]DfF",
                      "inputs": {
                        "DO0": {
                          "block": {
                            "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                            "fields": {
                              "NAME": "boardMethod:AddUnit",
                              "THIS": true
                            },
                            "id": ":a6n`RQPDW(NGd_Ww#ba",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "extraState": "<mutation></mutation>",
                                  "fields": {
                                    "TYPE": "board",
                                    "VAR": {
                                      "id": "A#l4Px0dcmhY=)J~;?X!"
                                    }
                                  },
                                  "id": "z?m5+g~;neOwL(=/zk4z",
                                  "type": "variables_get"
                                }
                              },
                              "ARG1": {
                                "block": {
                                  "fields": {
                                    "VAR": "Location/SPAWNAREA_MOB_004"
                                  },
                                  "id": "G.OZn_G4EAMv+o?*5Dc]",
                                  "type": "stringkeys_get"
                                }
                              },
                              "ARG4": {
                                "block": {
                                  "fields": {
                                    "NUM": 0
                                  },
                                  "id": "jNK,C[@I@YdD9KK]}]H^",
                                  "type": "math_number"
                                }
                              },
                              "ARG5": {
                                "block": {
                                  "fields": {
                                    "VAR": "Enemy"
                                  },
                                  "id": "N^u8rnGdcgC65DkeHx*)",
                                  "type": "teamtag_get"
                                }
                              },
                              "ARG6": {
                                "block": {
                                  "fields": {
                                    "NUM": 1
                                  },
                                  "id": "T~BS#O+m+ed-nC=9,~h/",
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
                            "id": "[/CtR~G[^ogRwGKD.A9I",
                            "inputs": {
                              "A": {
                                "block": {
                                  "id": "ii5{!lGB66TX[aB#7AfI",
                                  "inputs": {
                                    "DIVIDEND": {
                                      "block": {
                                        "fields": {
                                          "OP": "MINUS"
                                        },
                                        "id": "cJ`kB5G:6KC]6[TvRRIH",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "THIS": false,
                                                "VAR": "boardVariable:Tick"
                                              },
                                              "id": "^rW+[qI]x(LBr`;NXVHx",
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
                                              "id": ":=CU5+#-tu)5Y]B@i,zx",
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
                                        "id": "fqY]N!j,]G~b*_rnT.V!",
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
                                  "id": "@_uUkF.zW-Qs0~+3^gPg",
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
              "id": "F{Re)YBCeM_5czxkuLvu",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "mZNnf)7ObD,X{ASXZ0a(",
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
                          "id": "|Pa|dg1zXofD/jk80.Ve",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 2
                          },
                          "id": "!MwFagC2j_^67aFP?Nm-",
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
                    "id": "X:7NxmI#(voEj!ouqeVT",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "Y.=DN1dTrG*agn3wHJZL",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "THIS": false,
                                  "VAR": "boardVariable:Tick"
                                },
                                "id": "R[YUlm4p.Q-J$qksEbEc",
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
                                "id": ")!)cn8OF.#0,Ru[+k^eU",
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
                          "id": "*V]f.$TT{fCF4V[u%lj(",
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
                          "TEXT": "Battle_04_03"
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
                      "id": "d37n]Rticy-s]*8K_WNg",
                      "inputs": {
                        "DELTA": {
                          "shadow": {
                            "fields": {
                              "NUM": 1
                            },
                            "id": "0{|P~5:mT3Ivl5-.spT(",
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
                      "type": "math_change"
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
            "type": "controls_if"
          }
        },
        "type": "controls_if",
        "x": 695,
        "y": -695
      },
      {
        "id": ":EMUxr]Wi;5s8og8ry:W",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "NAME": "Log"
              },
              "id": "2t{lPG|I0^g1H*Pt}0]|",
              "inputs": {
                "TEXT": {
                  "block": {
                    "fields": {
                      "TEXT": "Battle_04_03 spawn!"
                    },
                    "id": "wc*s$s0f~),!ZuP`^nJJ",
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
                    "id": "xQgak.M(%MW.R6xn6iV-",
                    "type": "variables_get"
                  }
                }
              },
              "next": {
                "block": {
                  "id": "=u`hp0Pkd(9l;G5LF@f/",
                  "inputs": {
                    "DO0": {
                      "block": {
                        "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                        "fields": {
                          "NAME": "boardMethod:AddUnit",
                          "THIS": true
                        },
                        "id": "LId$YwXBsB;5HH+OTvy/",
                        "inputs": {
                          "ARG0": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": "u(L_(nv*+6fAqo!=?~`q"
                                }
                              },
                              "id": "an1v=q2t!QnmVG3FfoD^",
                              "type": "variables_get"
                            }
                          },
                          "ARG1": {
                            "block": {
                              "fields": {
                                "VAR": "Location/SPAWNAREA_MOB_004"
                              },
                              "id": "@od-oj`EOlo%n||-mggI",
                              "type": "stringkeys_get"
                            }
                          },
                          "ARG4": {
                            "block": {
                              "fields": {
                                "NUM": 0
                              },
                              "id": "6UJlU{^ZS0P9SwG]/1lK",
                              "type": "math_number"
                            }
                          },
                          "ARG5": {
                            "block": {
                              "fields": {
                                "VAR": "Enemy"
                              },
                              "id": "P;b0y.6.b]/f,jER*;.~",
                              "type": "teamtag_get"
                            }
                          },
                          "ARG6": {
                            "block": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "CjwR;mj91OF(G$.L+g2!",
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
                        "id": "HH]3,vzjwc,F!)y=A$bv",
                        "inputs": {
                          "A": {
                            "block": {
                              "id": ",GWo/{Rk:3jzhw-j:k7?",
                              "inputs": {
                                "DIVIDEND": {
                                  "block": {
                                    "fields": {
                                      "OP": "MINUS"
                                    },
                                    "id": "8U:R8k-M-}2Ec*$AJgM}",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "fields": {
                                            "THIS": false,
                                            "VAR": "boardVariable:Tick"
                                          },
                                          "id": "YHg1^8}LA;L8Lx%CagBN",
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
                                          "id": "yEHrg^pdi~L+QNnHoEKN",
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
                                    "id": "^/=]Cn/()xckL@O=vn3v",
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
                              "id": "Vu*~46dJijph2[$*$;oD",
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
                      "id": "=%%EL(Jy2zi!}2o@!0~|",
                      "inputs": {
                        "DO0": {
                          "block": {
                            "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                            "fields": {
                              "NAME": "boardMethod:AddUnit",
                              "THIS": true
                            },
                            "id": "41tF?lpa?m#{EZgl#0nU",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "extraState": "<mutation></mutation>",
                                  "fields": {
                                    "TYPE": "board",
                                    "VAR": {
                                      "id": "A#l4Px0dcmhY=)J~;?X!"
                                    }
                                  },
                                  "id": "wv_VoX9AKWKxE`3V^nB-",
                                  "type": "variables_get"
                                }
                              },
                              "ARG1": {
                                "block": {
                                  "fields": {
                                    "VAR": "Location/SPAWNAREA_MOB_004"
                                  },
                                  "id": "*(Gm_q}w7mhP5GMm3).z",
                                  "type": "stringkeys_get"
                                }
                              },
                              "ARG4": {
                                "block": {
                                  "fields": {
                                    "NUM": 0
                                  },
                                  "id": "oHcLBXP0@[5pBJB.61r[",
                                  "type": "math_number"
                                }
                              },
                              "ARG5": {
                                "block": {
                                  "fields": {
                                    "VAR": "Enemy"
                                  },
                                  "id": "Dsh`r)7iK%i9u-,3k(tz",
                                  "type": "teamtag_get"
                                }
                              },
                              "ARG6": {
                                "block": {
                                  "fields": {
                                    "NUM": 1
                                  },
                                  "id": "@]$j`$E5|,2VaEOWI`fn",
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
                            "id": "w:I78x!agE=HQHI`rc~j",
                            "inputs": {
                              "A": {
                                "block": {
                                  "id": "RUyC**BDN|^{]6snp%q9",
                                  "inputs": {
                                    "DIVIDEND": {
                                      "block": {
                                        "fields": {
                                          "OP": "MINUS"
                                        },
                                        "id": "R;)}2+ganU}*/nO^+PM-",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "THIS": false,
                                                "VAR": "boardVariable:Tick"
                                              },
                                              "id": "PZ/+W0IVBDk,/7bhUl4G",
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
                                              "id": "t+-G~FJd0E@YXCPE$F|1",
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
                                        "id": "o#@2}KN+K8zUlA=d,n!k",
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
                                  "id": "$%@Ko%-/qb:d]w,tXbe4",
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
              "id": "voIOA5l4XO`5b}E%Z/)3",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "p2N7SgPUQEg?^PNYc*4d",
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
                          "id": "=[F-7nfXq}iEW^7=wLO,",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 3
                          },
                          "id": "m;?$ICk$Jz|Gk6B~1v}G",
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
                    "id": "W06Q?q6+=bbK_EA-lPA9",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "4|5oNmi5#)]jCl[k%c`3",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "THIS": false,
                                  "VAR": "boardVariable:Tick"
                                },
                                "id": "x0OET[jlvQ]dDT2=T]N~",
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
                                "id": "IWAG[2xIWeWqRo;hKg0^",
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
                          "id": "bJ-WptOgq/B/2u(2;TW(",
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
                          "TEXT": "Battle_04_04"
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
                      "id": "Z`7Ux,;d.n_h6qX4jBul",
                      "inputs": {
                        "DELTA": {
                          "shadow": {
                            "fields": {
                              "NUM": 1
                            },
                            "id": "kG;flWG@T}by@}=m6oWQ",
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
                      "type": "math_change"
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
            "type": "controls_if"
          }
        },
        "type": "controls_if",
        "x": 755,
        "y": 355
      },
      {
        "id": "VgPj.e^+]Iu^ru|aW[~C",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "NAME": "Log"
              },
              "id": "DHxA8##IV{*Fq,/Fxu6b",
              "inputs": {
                "TEXT": {
                  "block": {
                    "fields": {
                      "TEXT": "Battle_04_04 spawn!"
                    },
                    "id": "1-EPNCMyY01i7,iauRl!",
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
                    "id": "n/o}IJ=Vvp[er-#2,asr",
                    "type": "variables_get"
                  }
                }
              },
              "next": {
                "block": {
                  "id": "C/R6T]}@HPj;@Eku@RCi",
                  "inputs": {
                    "DO0": {
                      "block": {
                        "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                        "fields": {
                          "NAME": "boardMethod:AddUnit",
                          "THIS": true
                        },
                        "id": "3)GRWW8VT{icaK=QLcTm",
                        "inputs": {
                          "ARG0": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": ",z?-{}Oa.puv7PUu9FZo"
                                }
                              },
                              "id": "j^TzY*myi0JcqMhL5CZ%",
                              "type": "variables_get"
                            }
                          },
                          "ARG1": {
                            "block": {
                              "fields": {
                                "VAR": "Location/SPAWNAREA_MOB_004"
                              },
                              "id": "essvX1LTgL#|6BJ,F|JF",
                              "type": "stringkeys_get"
                            }
                          },
                          "ARG4": {
                            "block": {
                              "fields": {
                                "NUM": 0
                              },
                              "id": "i8QVOHfFmQ(5vLTI#bZl",
                              "type": "math_number"
                            }
                          },
                          "ARG5": {
                            "block": {
                              "fields": {
                                "VAR": "Enemy"
                              },
                              "id": "0*b:~zjl|0rlHg*7^nn?",
                              "type": "teamtag_get"
                            }
                          },
                          "ARG6": {
                            "block": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "7e:-h~(Un:eTD#xCrVQ=",
                              "type": "math_number"
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
                            "id": "gy*f7ihm8[tRi,eh^Sbf",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "extraState": "<mutation></mutation>",
                                  "fields": {
                                    "TYPE": "board",
                                    "VAR": {
                                      "id": "u(L_(nv*+6fAqo!=?~`q"
                                    }
                                  },
                                  "id": "*]QP[n*A{!7yoLR;;#cr",
                                  "type": "variables_get"
                                }
                              },
                              "ARG1": {
                                "block": {
                                  "fields": {
                                    "VAR": "Location/SPAWNAREA_MOB_004"
                                  },
                                  "id": "K?Vtw|7ng}`P[lv._=Te",
                                  "type": "stringkeys_get"
                                }
                              },
                              "ARG4": {
                                "block": {
                                  "fields": {
                                    "NUM": 0
                                  },
                                  "id": "gB_ClcSA?G+Va@-xam4?",
                                  "type": "math_number"
                                }
                              },
                              "ARG5": {
                                "block": {
                                  "fields": {
                                    "VAR": "Enemy"
                                  },
                                  "id": "N+UYTbGeSXm1XO0o0@!L",
                                  "type": "teamtag_get"
                                }
                              },
                              "ARG6": {
                                "block": {
                                  "fields": {
                                    "NUM": 1
                                  },
                                  "id": "FLw-$LDH@AnMW~@vUP!%",
                                  "type": "math_number"
                                }
                              }
                            },
                            "type": "function_call"
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
                        "id": "E0)q7*zI==gKd+gk;4Jn",
                        "inputs": {
                          "A": {
                            "block": {
                              "id": "TwITk2b$H5F;toP2D@Gj",
                              "inputs": {
                                "DIVIDEND": {
                                  "block": {
                                    "fields": {
                                      "OP": "MINUS"
                                    },
                                    "id": "ITuiv@E+h*3f,oG[,oH@",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "fields": {
                                            "THIS": false,
                                            "VAR": "boardVariable:Tick"
                                          },
                                          "id": "cVe#Gcr2W`KjlokMqRY}",
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
                                          "id": "[:aUyFxx-roAuq$3zL_S",
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
                                    "id": "o{uf;vM);gqWr^t4W6PT",
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
                              "id": "eqmoFeb0H.5YF,pb3?}8",
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
                      "id": "JxD5w$EkTdCj0a:X-0?8",
                      "inputs": {
                        "DO0": {
                          "block": {
                            "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                            "fields": {
                              "NAME": "boardMethod:AddUnit",
                              "THIS": true
                            },
                            "id": "/|GZFJT0fnnZ[)T[A`S-",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "extraState": "<mutation></mutation>",
                                  "fields": {
                                    "TYPE": "board",
                                    "VAR": {
                                      "id": "A#l4Px0dcmhY=)J~;?X!"
                                    }
                                  },
                                  "id": "0gF_LC10;CqDF+TdLIEj",
                                  "type": "variables_get"
                                }
                              },
                              "ARG1": {
                                "block": {
                                  "fields": {
                                    "VAR": "Location/SPAWNAREA_MOB_004"
                                  },
                                  "id": "9$J7rvUEN}dYLZ6On{G9",
                                  "type": "stringkeys_get"
                                }
                              },
                              "ARG4": {
                                "block": {
                                  "fields": {
                                    "NUM": 0
                                  },
                                  "id": "eIeg88dBU)dpUZyg%huh",
                                  "type": "math_number"
                                }
                              },
                              "ARG5": {
                                "block": {
                                  "fields": {
                                    "VAR": "Enemy"
                                  },
                                  "id": "gl20xUcz1bC~X+D-$pKQ",
                                  "type": "teamtag_get"
                                }
                              },
                              "ARG6": {
                                "block": {
                                  "fields": {
                                    "NUM": 1
                                  },
                                  "id": "L%|KE6Fzd[PmEOWoA]lG",
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
                            "id": "L^~zem$C_sm^HokG?1,n",
                            "inputs": {
                              "A": {
                                "block": {
                                  "id": "-OxV?}^h!0Ul7dxa9VP[",
                                  "inputs": {
                                    "DIVIDEND": {
                                      "block": {
                                        "fields": {
                                          "OP": "MINUS"
                                        },
                                        "id": "_H0:~[HM0IVX*`dthe^M",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "THIS": false,
                                                "VAR": "boardVariable:Tick"
                                              },
                                              "id": "qcyM(8^6|409ziAS5^)R",
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
                                              "id": "{ZAY]qK8cK5A=x}oTkH}",
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
                                        "id": "z)/$/VNg8@@,oa/G]W4I",
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
                                  "id": "GqWaV}/=C.44h_~hx9oA",
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
                                          "id": "QxX0yIG9dXhfz~xvdfCh"
                                        }
                                      },
                                      "id": "ig_IuNaMWv:Uz!$GKllt",
                                      "type": "variables_get"
                                    }
                                  },
                                  "ARG1": {
                                    "block": {
                                      "fields": {
                                        "VAR": "Location/SPAWNAREA_MOB_004"
                                      },
                                      "id": "F}js7;BS?.WmN_~r}C@T",
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
                                "type": "function_call"
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
                                                      "id": "1_d:cLOn9Hs@h3RdE/[H"
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
                                              "NUM": 480
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
                                        "NUM": 180
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
              "type": "debug"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "AND"
              },
              "id": "Pg0ae4TsSAx.k.a^h:6.",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "qMw8/l?ggour6@CyvEb-",
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
                          "id": "KpPuoL9$_m~{FKn(^W5H",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 4
                          },
                          "id": "QLx70Q%SY9Oqp%y7@O;R",
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
                    "id": "?N4ZKOe1%`(~vasp_`-b",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "Uo[_ZwRy|Dg@1u}`7y?,",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "THIS": false,
                                  "VAR": "boardVariable:Tick"
                                },
                                "id": "iv8F{WB0ib%_|QOK}Czl",
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
                                "id": "omEx5cbW0y#V[+WXkLt!",
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
                          "id": ",V7qU^8pD5,)S-y|Q4M9",
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
        "y": 1385
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "MAP_ONUPDATE_TUTORIAL_WAVE4",
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
      "id": "6z_uaa_h[OKW.492_E8C",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "{Lm:iaI~lFFH+1H?0NO7",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "Ph1.4I;S|tRS:@?]nCy(",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "JgWBG`nZ~qT6-|E3c1Qv",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "tJ:n?pZ.hkC*oJ+d95X:",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "C$8,g(e]:-M]ez{3c4^X",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "LnM`5TTVJ}wUPbAn9T,-",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "JysXayY[EGD];!n:[R:m",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": ")T^icL5an*%{04(q%.},",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "Zm!j1%?ZUadCk4pS#6tw",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "Wl24ZgkZ?;#ntn9}MpLM",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "9@$J4/4FIQ]WlITmZ6nO",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "S*IaUTEnlO*hJ{%h,{pT",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "qm}W{8L,;a0k/eUwDCP;",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "AV`}-8MDkp^GN4H+kc,C",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "LY2E5:P2u]+=3(-:?R!z",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "hW8!Oiqh^i?_uT7{$7F/",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "C9s!CTqX.lrIxf%Y3w@x",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "#U.,,(8;b?yKQV#doq|P",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "@PcEP1M8p;aXR@sS[ZR)",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "XO7tdA2EBU,(T$U/IcVi",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "Y78=o}|h/U$nbkr*]rrx",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "?nk$|MdKU(41bqWpl9.+",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "dW$f4x5j,?}#/w+TiR0/",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "[a9V4X]nQDcvIb{A|r+k",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "UrbwIKuqs3eO{D.!{%1c",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "1F%Det};`ta*JN+e|^xT",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "9lSDdxmdttC4xI:,|V:^",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "VCj4#-9%o_)INeXdb^]]",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "/%xtCyxlVgy|atN[84K}",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "c2o|4P2udr|LG*!_OM$@",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "1swo;d+*T_ey}n,#dO_d",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "zmo:s6HDK8T@vY;Y?wxn",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "rS{[M!jACtZ{-zo*(MFy",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "QWkE.%/C~kDFn/S=!y/`",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "zR%pI!RZUynln3-.[5gl",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "Q!g{hmCWA#@um0OM@CBL",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "H)^6E_-U$6Vz;l_DFf2g",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "H#v}|~Ottd~oL=St6wy@",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "TkyQ%Zi#S+@@yrN!$IXH",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "!$$W1/pM$gTjFGLeWAN2",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "TmK{`8]ZsOU_NP$+aP[^",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "4#%W.h_$X%|rgp5Gvx;s",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "{$a+|Xm7|?9(7OMV11C`",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": ".$B!xpRK=-yDkrE!;Lw[",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "NBS].xWV/N-8lwd}GrB4",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "9pGppCG?BGm3M(euxA.?",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": ":u2@m(+K=dl*X1swehc[",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "J=XHMod^Ab)m^q6QFx,k",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "i@M);@5!x(ViU1XdiJ!4",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "BS;[%/yF%h03U06IAFLq",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "V6+Xy07sBC1mc{ou$%ki",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "]khqO@2@GA07pVa!6h*m",
      "name": "Gem shops"
    },
    {
      "id": "Z1|USs^!L-x=9xOs/?}l",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "RLoF20)42Hiksk?n:O!.",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "ib3=?L=,9R5lg8:Rp+gq",
      "name": "Map/Wave"
    },
    {
      "id": "bm;_mfo=%seYzup=z($L",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "hztzq;7k?.@/)9nTBueI",
      "name": "Map/Wave/Step"
    },
    {
      "id": "F*KGfqoK}aQw)tgFmW!d",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "Jv]|wmpd`9*$Z].%E~rO",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "!?s(H%U7?kjHg|[@kQK1",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "Yh^7qv2p+|(6(WKrbFyr",
      "name": "Map/Wave/State"
    }
  ]
}