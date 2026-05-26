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
        "x": 765,
        "y": -2595
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
                            "TEXT": "Battle_03_01"
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
        "x": 745,
        "y": -2285
      },
      {
        "id": "?$SG~nC*mRXyEE}2/F|C",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "NAME": "Log"
              },
              "id": "DP=drpWt+Mz+;C5Sl}4u",
              "inputs": {
                "TEXT": {
                  "block": {
                    "fields": {
                      "TEXT": "Battle_03_01 spawn!"
                    },
                    "id": "%]BB.LX=`j`=$at_S:h=",
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
                                  "id": "^-(5|M6dM/uO`u%BZn*{"
                                }
                              },
                              "id": "sG=F6co8*7sDlo=:+]eh",
                              "type": "variables_get"
                            }
                          },
                          "ARG1": {
                            "block": {
                              "fields": {
                                "VAR": "Location/SPAWNAREA_MOB_003"
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
                        "id": "I6+e-+FP0M/@kpVAq_yb",
                        "inputs": {
                          "A": {
                            "block": {
                              "id": "Dx^{T3H{#Q-lCXA=y0ZY",
                              "inputs": {
                                "DIVIDEND": {
                                  "block": {
                                    "fields": {
                                      "OP": "MINUS"
                                    },
                                    "id": ")gZ%J,8t!.u)hkMIhb-w",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "fields": {
                                            "THIS": false,
                                            "VAR": "boardVariable:Tick"
                                          },
                                          "id": "Py5`pE[JrEpMBaD?.a5j",
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
                                          "id": "f-uQ=tw(nKhg)C.yFHIw",
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
                                    "id": "5@KHH4wvLFutZ?8P7Hiu",
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
                              "id": "lnwOYe!w64pKp=u1;PxO",
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
                            "id": "O5Sj8A4L@]f_hye285b:",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "extraState": "<mutation></mutation>",
                                  "fields": {
                                    "TYPE": "board",
                                    "VAR": {
                                      "id": "xMT^SABbiyU!b8sVy!,X"
                                    }
                                  },
                                  "id": ",Xyob;AZ2pE,74|Xu8zR",
                                  "type": "variables_get"
                                }
                              },
                              "ARG1": {
                                "block": {
                                  "fields": {
                                    "VAR": "Location/SPAWNAREA_MOB_003"
                                  },
                                  "id": "Q.S9!|onBZNt3Ckl%Y*R",
                                  "type": "stringkeys_get"
                                }
                              },
                              "ARG4": {
                                "block": {
                                  "fields": {
                                    "NUM": 0
                                  },
                                  "id": ".41TfU9nn]u,eKl]1NR?",
                                  "type": "math_number"
                                }
                              },
                              "ARG5": {
                                "block": {
                                  "fields": {
                                    "VAR": "Enemy"
                                  },
                                  "id": "B)0He|Lzi=SBgC*|vN4X",
                                  "type": "teamtag_get"
                                }
                              },
                              "ARG6": {
                                "block": {
                                  "fields": {
                                    "NUM": 1
                                  },
                                  "id": "H,dKBtzVYY^fXV|^piN1",
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
              "id": "YNRFutRwTN(BsM/aQF.W",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": ":2qMi!=}x/E7Ek/!2Sb4",
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
                          "id": "bp;pH,z:QjtS`yNv[;!]",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "|8j)GEP$tk@9SqPFNpm9",
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
                    "id": "_ibOoUqvqvui#N1b8~`w",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "+dmSLrIoSH9i1_EVnnKN",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "THIS": false,
                                  "VAR": "boardVariable:Tick"
                                },
                                "id": "y*k9jm$c8ScR?Rw](cTZ",
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
                                "id": "YA+X(NSf(ZU4|nW;[x`F",
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
                          "id": "Z4%^7~7!_}nYy,`)6=})",
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
                          "TEXT": "Battle_03_02"
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
        "x": 745,
        "y": -1865
      },
      {
        "id": "b$g0ySH_hIXMWs:r9hk+",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "NAME": "Log"
              },
              "id": "m6}!G/yszX,F@kPC.;0I",
              "inputs": {
                "TEXT": {
                  "block": {
                    "fields": {
                      "TEXT": "Battle_03_02 spawn!"
                    },
                    "id": "SgZ`xF?MC+aVjQ@Qa_uP",
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
                    "id": "`z|$9?5CRn)pkbQjqrFc",
                    "type": "variables_get"
                  }
                }
              },
              "next": {
                "block": {
                  "id": "AOs{}xu7XlJgX~UgGA5Z",
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
                                  "id": "2Y}uu`z-*0-khq75IN~g"
                                }
                              },
                              "id": "vbKws_mwt9ETdIZu-+??",
                              "type": "variables_get"
                            }
                          },
                          "ARG1": {
                            "block": {
                              "fields": {
                                "VAR": "Location/SPAWNAREA_MOB_003"
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
                        "id": "^wpvng;OD{2Bg`*[AZ38",
                        "inputs": {
                          "A": {
                            "block": {
                              "id": "F]x*^eI1y+KFSA{jgz%1",
                              "inputs": {
                                "DIVIDEND": {
                                  "block": {
                                    "fields": {
                                      "OP": "MINUS"
                                    },
                                    "id": "3oc2^@~-iw[MHEZBh4^r",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "fields": {
                                            "THIS": false,
                                            "VAR": "boardVariable:Tick"
                                          },
                                          "id": "?95=|dLYqx9RDr|8s6/C",
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
                                          "id": "S?d@D8g]UG-$Gx?=r+*k",
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
                                    "id": "l!+w.K4OR~EOG/*X3gt8",
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
                              "id": "1LMk;tws/o5C.A2P^Bw6",
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
                      "id": "Q]~D(;%KW^0cS=Y{jy(]",
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
                                      "id": "xMT^SABbiyU!b8sVy!,X"
                                    }
                                  },
                                  "id": "z?m5+g~;neOwL(=/zk4z",
                                  "type": "variables_get"
                                }
                              },
                              "ARG1": {
                                "block": {
                                  "fields": {
                                    "VAR": "Location/SPAWNAREA_MOB_003"
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
                            "id": "A|Y[jETGK9e9UcFxrCVM",
                            "inputs": {
                              "A": {
                                "block": {
                                  "id": "=2UFzC2{8PJUwUgk)dW~",
                                  "inputs": {
                                    "DIVIDEND": {
                                      "block": {
                                        "fields": {
                                          "OP": "MINUS"
                                        },
                                        "id": "pz]:g@yG!YRL3#m%t_2?",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "THIS": false,
                                                "VAR": "boardVariable:Tick"
                                              },
                                              "id": "$w|K*n!P(cgEX;vW[Jb8",
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
                                              "id": "oKOeXrr;y=MY-JQTv]7y",
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
                                        "id": "P]Drt1btyp=HgkEo;w}}",
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
                                  "id": "/`x[];e0`}O{S)EhlNRh",
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
              "id": "|,$uq)q.!.A#@!n7gh]V",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "UMu,:A`T5!w^RHgJSnd@",
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
                          "id": "Y9+Y=dNE,xlD|LDq=.~7",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 2
                          },
                          "id": "$qieIM4cSU-+YAa05+Y5",
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
                    "id": "H9fH!v$PW-*EQS1HOS[L",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": ":NDV`H_-Vj=N~J7:0p.w",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "THIS": false,
                                  "VAR": "boardVariable:Tick"
                                },
                                "id": "^_*;?9XWMG[C-dgx;{Ey",
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
                                "id": "rL}QeOws!ri+ONfQym6r",
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
                          "id": "N%UMZ2QgQ7-eBs^;;Aq.",
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
                          "TEXT": "Battle_03_03"
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
        "x": 764,
        "y": -770
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
                        "id": ".vm[{AVKeqaUN]0O..$,",
                        "inputs": {
                          "ARG0": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": "@zleR-JSPMFL;tln)E8$"
                                }
                              },
                              "id": "S++ih:e|27oXT:%,Vm~N",
                              "type": "variables_get"
                            }
                          },
                          "ARG1": {
                            "block": {
                              "fields": {
                                "VAR": "Location/SPAWNAREA_MOB_003"
                              },
                              "id": "7H$omyNB((FLg}g`5d~p",
                              "type": "stringkeys_get"
                            }
                          },
                          "ARG4": {
                            "block": {
                              "fields": {
                                "NUM": 0
                              },
                              "id": "_}?R:f}-5~]BO(F)c%p-",
                              "type": "math_number"
                            }
                          },
                          "ARG5": {
                            "block": {
                              "fields": {
                                "VAR": "Enemy"
                              },
                              "id": "Irx~obWc#QOYQ,v{U(;(",
                              "type": "teamtag_get"
                            }
                          },
                          "ARG6": {
                            "block": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "mG16(Z^^pA6/vx1-^[c^",
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
                            "id": "41tF?lpa?m#{EZgl#0nU",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "extraState": "<mutation></mutation>",
                                  "fields": {
                                    "TYPE": "board",
                                    "VAR": {
                                      "id": "^-(5|M6dM/uO`u%BZn*{"
                                    }
                                  },
                                  "id": "wv_VoX9AKWKxE`3V^nB-",
                                  "type": "variables_get"
                                }
                              },
                              "ARG1": {
                                "block": {
                                  "fields": {
                                    "VAR": "Location/SPAWNAREA_MOB_003"
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
                            "NUM": 3
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
                          "TEXT": "Battle_03_04"
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
        "y": 285
      },
      {
        "id": "`|isREk/D}w%Ex*ryRWa",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "NAME": "Log"
              },
              "id": ".abv4DUJG7Z8t;6=-x#I",
              "inputs": {
                "TEXT": {
                  "block": {
                    "fields": {
                      "TEXT": "Battle_03_04 spawn!"
                    },
                    "id": ")?zh5bCvjA!=(dn8MU2i",
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
                    "id": "ymTq5f9t#45aPY+K;6:S",
                    "type": "variables_get"
                  }
                }
              },
              "next": {
                "block": {
                  "id": "Ei:|-+VXNK98F!HoJJ7B",
                  "inputs": {
                    "DO0": {
                      "block": {
                        "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                        "fields": {
                          "NAME": "boardMethod:AddUnit",
                          "THIS": true
                        },
                        "id": "b]B/Zm*91e#Y$5}Z;hfm",
                        "inputs": {
                          "ARG0": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": "@zleR-JSPMFL;tln)E8$"
                                }
                              },
                              "id": "9P]!jCJC$DP-JAx,~mC!",
                              "type": "variables_get"
                            }
                          },
                          "ARG1": {
                            "block": {
                              "fields": {
                                "VAR": "Location/SPAWNAREA_MOB_003"
                              },
                              "id": "Y2LLx?x^!dm$|rr0km`0",
                              "type": "stringkeys_get"
                            }
                          },
                          "ARG4": {
                            "block": {
                              "fields": {
                                "NUM": 0
                              },
                              "id": "WPL[SXM@riu69In:E6dq",
                              "type": "math_number"
                            }
                          },
                          "ARG5": {
                            "block": {
                              "fields": {
                                "VAR": "Enemy"
                              },
                              "id": "$If|QBtQHKm9=,+N5TX6",
                              "type": "teamtag_get"
                            }
                          },
                          "ARG6": {
                            "block": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": ".d-rro/=P7NzD38/pk:4",
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
                        "id": "UpMU8XXNLyi1rJJ.y%*N",
                        "inputs": {
                          "A": {
                            "block": {
                              "id": ".`~]mcSCa-Hh(GB.AI{w",
                              "inputs": {
                                "DIVIDEND": {
                                  "block": {
                                    "fields": {
                                      "OP": "MINUS"
                                    },
                                    "id": "q4(,AF@`Wy?Z7|FeCfT*",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "fields": {
                                            "THIS": false,
                                            "VAR": "boardVariable:Tick"
                                          },
                                          "id": "|LAr~QTY{8O0V%78Lih$",
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
                                          "id": "NJl@FpC`LVh293~1KxWX",
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
                                    "id": "1t#y@Q`T_MEn4L3]Yax/",
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
                              "id": "d-4QB~sa!FPoV5Dx8Yg_",
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
                      "id": "D@I@{KK@q14l_ay=UYH9",
                      "inputs": {
                        "DO0": {
                          "block": {
                            "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                            "fields": {
                              "NAME": "boardMethod:AddUnit",
                              "THIS": true
                            },
                            "id": "i=l=lTu]iDis%bqQy71c",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "extraState": "<mutation></mutation>",
                                  "fields": {
                                    "TYPE": "board",
                                    "VAR": {
                                      "id": "xMT^SABbiyU!b8sVy!,X"
                                    }
                                  },
                                  "id": "16j14pms1[m`ULHquj^=",
                                  "type": "variables_get"
                                }
                              },
                              "ARG1": {
                                "block": {
                                  "fields": {
                                    "VAR": "Location/SPAWNAREA_MOB_003"
                                  },
                                  "id": "{5[e-{K4?B4R]_?U5}Gs",
                                  "type": "stringkeys_get"
                                }
                              },
                              "ARG4": {
                                "block": {
                                  "fields": {
                                    "NUM": 0
                                  },
                                  "id": ";OvntUfW/{M7kIM~}nYw",
                                  "type": "math_number"
                                }
                              },
                              "ARG5": {
                                "block": {
                                  "fields": {
                                    "VAR": "Enemy"
                                  },
                                  "id": ",zUkGN+^=Q37[Tq2%+Ip",
                                  "type": "teamtag_get"
                                }
                              },
                              "ARG6": {
                                "block": {
                                  "fields": {
                                    "NUM": 1
                                  },
                                  "id": "({)2b2le6Ad`IeDOrzkc",
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
                            "id": "JMM9w-qp!A!+Q8uPF:uI",
                            "inputs": {
                              "A": {
                                "block": {
                                  "id": "`62[,s.EB$rm)Cb71oLq",
                                  "inputs": {
                                    "DIVIDEND": {
                                      "block": {
                                        "fields": {
                                          "OP": "MINUS"
                                        },
                                        "id": "_G![M@mv+?y${/98G?%D",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "THIS": false,
                                                "VAR": "boardVariable:Tick"
                                              },
                                              "id": "Tyj(lvHj8H{drtEdqhB=",
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
                                              "id": "F}`g7Uw-39n)]M!Qo4GF",
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
                                        "id": "XNA+|b4H]Loi$[rW^+_)",
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
                                  "id": "XXknUX=r@2,1nr/mL,Ym",
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
              "id": "KTGkog|7z4:g$j17LFR!",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "o^(JB1GJlJ[%z1!=lYEo",
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
                          "id": "Fn|}DuP)3t(8!(?|{)B{",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 4
                          },
                          "id": "Sm3V6i6JS)|5Y.%|;i$V",
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
                    "id": "a|yIIku6_P!)}w:ulw1k",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "hJZ`RrA80k_Uv[y%S;IO",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "THIS": false,
                                  "VAR": "boardVariable:Tick"
                                },
                                "id": "~L@ZqDUDd9(6+@KCJ;9)",
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
                                "id": "KELNma^8WcqJ7;oUFJp;",
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
                          "id": "B=_Ly8!`U~Pc]V4]{N2q",
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
        "y": 1325
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
                                    "id": "#bD!l5[N?lFETNMb#dB:"
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
        "x": 1045,
        "y": 2345
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "MAP_ONUPDATE_TUTORIAL_WAVE3",
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
      "id": "2.S}2-^tIV=qj*=`7u[@",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "]Asa5C-lMS*L=KV]^98y",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "hxEMU5u~WOrTbd8Q;$+{",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "a.hqTg(~ynbs!!t#|iP|",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "5EL3U(EKXRQ)|tSSO3#p",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "@$FMRw^z/,bxbn_G#zJc",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "}Fh},3NpX0,9d|8K,Bzu",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "q$Y,yO_w;ye`k)dboGfE",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "5F~Xo?Xgg2_iSDTJGON=",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "uT:yS(s+^IDuXV)g.CQ8",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "^[i.}v39^[enVL.@A?Fi",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "g^2@?2tPb~QB~.~eM*]H",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": ",Ia]zz;4R%_^]FKw8WTM",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "xwwf+4bo^EJzrFz(PG2?",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "3a.8;BOUN0p#]GqtT7n]",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "^-(5|M6dM/uO`u%BZn*{",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "2Y}uu`z-*0-khq75IN~g",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "ld4CIeYbNsV}0bjz)/UI",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "4CpmYNwvDL;LY^2v}qsT",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "W..Q_R-=C}`@2$WiY=V9",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "B/b$cdIX+`W9TW[L1M5g",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": "5G%mK4IDDt~)},6^V5/w",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "3J7:paY.0zy5O2:1(+Oc",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "xFo`K1GK4b!1+Q[wG+o*",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "gB}($3Zje~j/V:Np)Kr-",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "6~`d/C~vj7+$G/|5Z53T",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "z|RyWeVoo-Yx3}wl6_t(",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "Gyyc8p2(Kpr7=j[s/#AP",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": ":_a!Mc$:O;QA0^mZfp1:",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "?y7i$%AEXb(y3K[ZmXSe",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "YlY6|rZD#e,Ruv}csf*J",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "3N;v~#YFOA$y{9|+w?3C",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "=F)@i%K-*T|4+Q4%uQ2f",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "ykuK7vWWCG,ZGx{f+{R2",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "{d+cz0Kva6PJI0xpQjGV",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "xMT^SABbiyU!b8sVy!,X",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "f2mJTTcpPQe)3J-_+9D%",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "w0NqhfZOfu)/}Ua$,cz|",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "-Y7d+t$2q)K)nbK{Sl^6",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "t$p?Cp2D*eUu87Yg..9k",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "_4o=yAq|u;H/-W/wOZ.?",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "|s.7SjYBeQ.n370bplt:",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": ";N88g(a%u?+2VZ6u.ka_",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "#%mEyKQH:]u*IMs.Pnd5",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": ",uI/hN1gT(2Ap,#~TZ~1",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "wXTjXyy{?GrcDBqlt[AC",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "T8,_RyY`y`ED7_fm)sS.",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "BaTx2/;.;W6r,6p3c|J_",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": "Gf~sC(vFF9[VtDuH/Ce9",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "#mm,hgs=PIEX,g09=,-9",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "%q-.sq*$8RpB[bmr9L[6",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "P68.j}H[u)k[`*#vki3:",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "QS(;1elCpIX)fTJaiNlX",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "hV.x33Lo|P:fP6ta)K2E",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "1T(y4b|`nJWmf_`0r?|o",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "@zleR-JSPMFL;tln)E8$",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "MGD)SpyQnPx]oIwCzgy?",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "Z~sUjavibV.|m+Tu#g^~",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "yzWupryJBsthH5x]-KgE",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "^?vBHmP/UPku@f/bg:#4",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": ";}OBaX%Xw?6*fq,GHy;I",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "5h5`AT|hQPb7vd4845r]",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "UK}vynL{p`R:vug%T)2j",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "CU,tNz(0#]Y;)jk5,o8%",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": "xGLW7jE*Gy9NzI.Vmi`L",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "kJXJ[1SrEhfG=SF.1_FM",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "?Zp4joTK}Nv-%%RW-QPL",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "#mW?9Pq)5R+vg:%TbxLR",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "Rd^bl6!.+`~d8S{iH`(5",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "Zq@R!5AJT+vhs}DLyK9T",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "UAZgwRbye=1kplZW.7,d",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "zON$qinz?(q6.3%P_3uE",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "#X-}gl)6y*]_uH92pi(6",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "i/hHeQK9Y#smo_CZXIw,",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "/L.l.v1{GFfIWf]nOOzT",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "}H?I4JvzcQdFkVJtnj!`",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "/K~Pb@Ao`[2XzfoZGU+n",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "/iSlD,r=6X|rJ6*l^J}N",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "!_$AHsbjxq`svW=?w?cY",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "QE/Z4x%{8%fDe2DR?ra=",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "#bD!l5[N?lFETNMb#dB:",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "RV(U1vW_Fa$rs^fpSzn]",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "Gro:Sn}9,Ja}DlB%U_oI",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "c,?UXmOr1$tKY[}v*ns^",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "_ijfMJ4$ai@6_aF}:Kmv",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "Ekhh?=ZX~QWh^Qz6vw,_",
      "name": "@Map/Variable01"
    },
    {
      "id": "/]fQ+9trYI{sl|wJw|lB",
      "name": "@Map/Variable02"
    },
    {
      "id": "lf%4,}Vw5b#WW8)vOV_,",
      "name": "@Map/Variable03"
    },
    {
      "id": "nOlD_Ljt.o7G}-Zo{`d1",
      "name": "@Map/Variable04"
    },
    {
      "id": "tdI]d_vYbq^$%$YCnoxD",
      "name": "@Map/Variable05"
    },
    {
      "id": "m3B!l=u;NIg9fm.Z`_y2",
      "name": "@Map/Encounter/Unit1ID"
    },
    {
      "id": "U-E^=PYF?9(b~n[V=l7p",
      "name": "@Map/Encounter/Unit2ID"
    },
    {
      "id": "H{N0$KUX-~TN)mi7`-3h",
      "name": "@Map/Encounter/Unit3ID"
    },
    {
      "id": "1X2$b,x]DrS:l!LZ}(s+",
      "name": "@Map/Encounter/Unit4ID"
    },
    {
      "id": "Y7)X;~3HCp#7VV.t8P:u",
      "name": "@Map/Encounter/Unit5ID"
    },
    {
      "id": "`;|PEhL[:1NReQ[yDlW+",
      "name": "@Map/Encounter/Unit1Percent"
    },
    {
      "id": "w$YaYv}+K4UBZo}W*k~-",
      "name": "@Map/Encounter/Unit2Percent"
    },
    {
      "id": "+=ELiJV5K8}u94VE{kL*",
      "name": "@Map/Encounter/Unit3Percent"
    },
    {
      "id": "sIF$tT@KK{(N1~1:F4N5",
      "name": "@Map/Encounter/Unit4Percent"
    },
    {
      "id": "UoTABl9AhA:#[MACs=~=",
      "name": "@Map/Encounter/Unit5Percent"
    },
    {
      "id": ";f)Q)r52h~XUCH[rvp1{",
      "name": "Map/WaveStartTick"
    },
    {
      "id": "9#LwZpP%,X%hpksaUr54",
      "name": "@Unit/Variable01"
    },
    {
      "id": "MyAJqU?_esziZZKWZ=4?",
      "name": "@Unit/Variable02"
    },
    {
      "id": "Nnz5`joU323KDYA=c]oU",
      "name": "@Unit/Variable03"
    },
    {
      "id": "~P67W0wpazc,~ASMQoT8",
      "name": "@Unit/Variable04"
    },
    {
      "id": "{`6hxmEwHf/NROIVITPk",
      "name": "@Unit/Variable05"
    },
    {
      "id": "yh[F=@9}/!A8`~VCskLw",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "XzXIQNm*cD*RB6~s7ycC",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "xEGwS~E?-p]W#V|MdDT2",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "G2eht}K2%#P8_j]lA,gr",
      "name": "@Skill/Trait/BlastIncreaseKBPercent"
    },
    {
      "id": "|e*tq@7Ese3d7C{yA=#?",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "o(J-ReB;hx|rp]F6Y4we",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": ".Dm%}3%So.-!fX0_[!@G",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "pK?+FM1px4`g[c*[uxh=",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "KXX[[^@0YMUi6tTbyQi9",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "@B/_g1/2QAE.s`$uzXyP",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "!|]b1$j|)tl!`DOQ/(55",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "Cv=}sByRe+r1r)=[OQ|x",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "*G8)VUS9.@PZG^HbQ2U7",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "gD=7LAc$B!gH/Fkg%xsk",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "wr95Rd2H4p5@4D!}q,9W",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": ";W=dO/2:hDOq:%z+vx;u",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "qP=d.7YHPZ?Rbk^.fUc$",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "|~*lejr0wJT}_Nb-c3Sl",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "E]J^l*-p!;0lpO4,|a?~",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "?Ts?IG@R=)k/W7viv]+c",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "(.k/ok~PbSdx@ZQDw,Ud",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "RvGySx0O#CxOcAGa?{+G",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "Qc7lT(DRb!V0e5O4QXX6",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "%oklwWPDI|*`[T%KzhQC",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "EV$/,j3G~z7vCo|RGeA.",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "0L-3*Ei4#x)*ts-e_*7x",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "Iaf[}XHbXxTs,HR_s2#i",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "R=5t`s9*Bq$ZOxJ%n{^X",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "8]1Eew2LS5B@E8!9j@*p",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": ",Q4e.9|ucsVp-y;/UR)/",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "C]HA@*2/DE!6kt?^y+M.",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "Fbzdq!T_RN[E?aK_ylhx",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "h[s$kf+jZhuV|Ivcp~pE",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "Q5GX1%22_zS@`kpD{~3;",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "Lu[mEB35|VIzgkcso5[v",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "_h1D2S5VI3H0*=38YNyN",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "_762+Q;0@;)A72/f+Go|",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "_tCd/(cgHL[Jsj***3^5",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "B3`oVkEw)]4xMgc.$|Kg",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "L%GVxhnuVs-gwnEe|9AJ",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "!bdXxFm_*`4YP1.MTIe?",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "e[2jgT~.7vhu5|IrrH1c",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "nl_/5ke1-S:E%3#6-yoK",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": ".cgKlOsv`2bb=]EXCWLw",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "a1EH-(/ele-:A@IR}hQ`",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "q40uX}$8*Xbws$o^jkzP",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "h,^}e9hCn1!lalS?J|21",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "_rzWlF?$X2{^Q[|LKYp0",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "8-.WniP!W7d.Y=^M%w30",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "SiHGF#nfzx:5cAS)0]0r",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "k*N[k@w4+c/b_N_pK-Nc",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "O|Hq)`hrf8Y$av}=!zhe",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "%P5%c#_gWKV2QRL%g1rB",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "T%(Dq2zfmx,c)[+(ESxV",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "Ls5Y5Mp=C;|K8xUs^y)q",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "DRLh{$Fi{CpI02~(OzZU",
      "name": "@Map/Wave5/Monster10"
    }
  ]
}