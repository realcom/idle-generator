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
                      "NUM": 2
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
        "x": 1215,
        "y": 365
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
                      "TEXT": "Default3_Battle_02_01"
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
                          "id": "F//i`5m5GJ/iAUoeO`l["
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
                                        "NUM": 1200
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
                    "id": "E~.?CD;pQ9KstDJ$!}_~",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "NUM": 18
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
        "x": 1215,
        "y": 575
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
            "id": "(|KiF;jkm^ZDVsRcPu(J",
            "inputs": {
              "DO0": {
                "block": {
                  "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Duration (필수)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "boardMethod:StartTimer",
                    "THIS": false
                  },
                  "id": "/e{KuC?L9YjF0*uCSJYx",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "fields": {
                          "NUM": 1
                        },
                        "id": "hzAh-[L(R^Lb3$mnYfmS",
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
                      "id": "x/$la+JF,.Q]B?m(4)f8",
                      "inputs": {
                        "VALUE": {
                          "block": {
                            "fields": {
                              "NUM": 2
                            },
                            "id": "o:O2:O9zIIjQt4|gP``8",
                            "type": "math_number"
                          }
                        }
                      },
                      "next": {
                        "block": {
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "MELJNwdH|Vh%8.,UoCq{"
                            }
                          },
                          "id": "A0ui6eGuWl:}Y^K8lzU-",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "NUM": 0
                                },
                                "id": "%aWi31Te-Q:b)sPAiNCI",
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
                  "id": "_kh]pcx*j#zgayh$UQf2",
                  "inputs": {
                    "A": {
                      "block": {
                        "fields": {
                          "OP": "AND"
                        },
                        "id": "]ux[Vp5dM:U%SJ(CfxUD",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "THIS": false,
                                "VAR": "unitVariable:HasTarget"
                              },
                              "id": "x}:*g:hQcn7#O@2M?3dQ",
                              "type": "variables_get_reserved"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "OP": "LTE"
                              },
                              "id": "R`DuC_fk!Y/O3i?t|aT+",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "THIS": false,
                                      "VAR": "unitVariable:TargetDistance"
                                    },
                                    "id": "0n0Il3cn=lNyH0EArP)b",
                                    "type": "variables_get_reserved"
                                  }
                                },
                                "B": {
                                  "block": {
                                    "fields": {
                                      "NUM": 12
                                    },
                                    "id": "Bx+A4#evNO^i#JHcKGA6",
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
                        "id": "y]*x~^o!-yIlWyN.A|m{",
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
                              "id": "F,St.[$XCqQM?w%eT5Ct",
                              "type": "variables_get"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "8l*Vy6I5AUEdgi8cj]0@",
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
                "id": "IY@SOgJzZ8q^;*m4G1)(",
                "inputs": {
                  "DO0": {
                    "block": {
                      "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                      "fields": {
                        "NAME": "boardMethod:UnBlockSkillAction",
                        "THIS": false
                      },
                      "id": "wSTa$h??,l7u]6Z)}u.Z",
                      "next": {
                        "block": {
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "F//i`5m5GJ/iAUoeO`l["
                            }
                          },
                          "id": "8NeNhy4tP*CLUz_A.g43",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "NUM": 3
                                },
                                "id": "S:N*V#LS9b{oJLC,~JZA",
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
                      "id": "sQ34*_5l~:HjZqARW$rk",
                      "inputs": {
                        "A": {
                          "block": {
                            "fields": {
                              "OP": "LTE"
                            },
                            "id": "pO{Iq}zE~997T*s?|k~H",
                            "inputs": {
                              "A": {
                                "block": {
                                  "fields": {
                                    "THIS": false,
                                    "VAR": "boardVariable:Timer"
                                  },
                                  "id": "77eY?yvv%=^K^R!5oQ!x",
                                  "type": "variables_get_reserved"
                                }
                              },
                              "B": {
                                "block": {
                                  "fields": {
                                    "NUM": 0
                                  },
                                  "id": "UdWDpbAq+=o_NYYqW739",
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
                            "id": "%XXw-;.#e$6Tbs1`[oG8",
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
                                  "id": "y3Nd9AD~xHAx;ek;M#Dk",
                                  "type": "variables_get"
                                }
                              },
                              "B": {
                                "block": {
                                  "fields": {
                                    "NUM": 2
                                  },
                                  "id": "32zC8i3/K]jEIt^3nb6K",
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
        "x": 1225,
        "y": 1065
      },
      {
        "id": "R8x;pE4rO|Wkq[vt*aWb",
        "inputs": {
          "DO0": {
            "block": {
              "id": "yTsc.Vm99wb~E5-`vhfE",
              "inputs": {
                "DO0": {
                  "block": {
                    "id": "Sr*toCQ{.~*]Y{dCRlwa",
                    "inputs": {
                      "DO0": {
                        "block": {
                          "id": "Eg#gH@uiZOrCRWEf7ASl",
                          "inputs": {
                            "DO0": {
                              "block": {
                                "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                "fields": {
                                  "NAME": "boardMethod:AddUnit",
                                  "THIS": true
                                },
                                "id": "]D_sQ)KI$;Wx=w;18,Wq",
                                "inputs": {
                                  "ARG0": {
                                    "block": {
                                      "extraState": "<mutation></mutation>",
                                      "fields": {
                                        "TYPE": "board",
                                        "VAR": {
                                          "id": "$jelyON;zDG@Y$;SvFa*"
                                        }
                                      },
                                      "id": "TnF5ZiwuyELB0W_g1Mzi",
                                      "type": "variables_get"
                                    }
                                  },
                                  "ARG1": {
                                    "block": {
                                      "fields": {
                                        "VAR": "Location/SPAWNAREA_MOB_002"
                                      },
                                      "id": "bUngP7Q29X1iulWp/F(Z",
                                      "type": "stringkeys_get"
                                    }
                                  },
                                  "ARG4": {
                                    "block": {
                                      "fields": {
                                        "NUM": 0
                                      },
                                      "id": "JZsB$e)U;f1lER.LR;BO",
                                      "type": "math_number"
                                    }
                                  },
                                  "ARG5": {
                                    "block": {
                                      "fields": {
                                        "VAR": "Enemy"
                                      },
                                      "id": "Q8b;n_Og8]m,J#)1o_h1",
                                      "type": "teamtag_get"
                                    }
                                  },
                                  "ARG6": {
                                    "block": {
                                      "fields": {
                                        "NUM": 1
                                      },
                                      "id": "=)#9i--?@5A:j)-8IJ,p",
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
                                "id": "=K)2di+w4X3sUvI5n:*N",
                                "inputs": {
                                  "A": {
                                    "block": {
                                      "id": "i8mFyC:RjJbL7nCZO#^`",
                                      "inputs": {
                                        "DIVIDEND": {
                                          "block": {
                                            "fields": {
                                              "OP": "MINUS"
                                            },
                                            "id": "u+{cR)-,-7E,rN3_-]}p",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "fields": {
                                                    "THIS": false,
                                                    "VAR": "boardVariable:Tick"
                                                  },
                                                  "id": "W?Us1j)^)rSe.}Id+o]9",
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
                                                  "id": "3z`]1C[`%{52amM(:@i7",
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
                                              "NUM": 52
                                            },
                                            "id": "KJGS|$Z#X-+:$WswO.#I",
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
                                      "id": "a[+JBZ/a.h,;+D0O`i]*",
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
                          "id": "fw7[9QIlF=Wc_}$6KC5+",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "OP": "MINUS"
                                },
                                "id": "b@6RgTzCE{N*Ot`Voefz",
                                "inputs": {
                                  "A": {
                                    "block": {
                                      "fields": {
                                        "THIS": false,
                                        "VAR": "boardVariable:Tick"
                                      },
                                      "id": "/zW]s9xlL5XH1.+ZbC52",
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
                                      "id": "u*KX(PNb+_DycQ;l(/fG",
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
                                "id": "!)-z?1yv%peUo))M2Ys-",
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
                    "id": "q%bb.QB[18:=C#%G3URF",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "Wsq;Ic.gAi;}nKV+m4Ak",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "THIS": false,
                                  "VAR": "boardVariable:Tick"
                                },
                                "id": "6^hqrGfo^;U]OC1o2mu1",
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
                                "id": "nALq(sLc4R-UW3Gt.?*G",
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
                          "id": "2C^f]:KUGc[.h1H/c}8o",
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
                  "id": "eUKU54@hs)3i3BY@*)G@",
                  "inputs": {
                    "DO0": {
                      "block": {
                        "id": "G@#%MjquBEKRhoLxR[sQ",
                        "inputs": {
                          "DO0": {
                            "block": {
                              "id": "?:DX@=Cl~t`v-#Af8rY]",
                              "inputs": {
                                "DO0": {
                                  "block": {
                                    "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                    "fields": {
                                      "NAME": "boardMethod:AddUnit",
                                      "THIS": true
                                    },
                                    "id": "fL]Blh38Uqm=^~`+CPVN",
                                    "inputs": {
                                      "ARG0": {
                                        "block": {
                                          "extraState": "<mutation></mutation>",
                                          "fields": {
                                            "TYPE": "board",
                                            "VAR": {
                                              "id": "HDtEO#yohrpf~5b$A.ua"
                                            }
                                          },
                                          "id": "WkI?dp4O_U:EP($T1C81",
                                          "type": "variables_get"
                                        }
                                      },
                                      "ARG1": {
                                        "block": {
                                          "fields": {
                                            "VAR": "Location/SPAWNAREA_MOB_002"
                                          },
                                          "id": "ol3xf%AD3dVH)A9@8*1t",
                                          "type": "stringkeys_get"
                                        }
                                      },
                                      "ARG4": {
                                        "block": {
                                          "fields": {
                                            "NUM": 0
                                          },
                                          "id": "]5xCezYFevY0lD08SXXt",
                                          "type": "math_number"
                                        }
                                      },
                                      "ARG5": {
                                        "block": {
                                          "fields": {
                                            "VAR": "Enemy"
                                          },
                                          "id": "3^KWsQu#k!F{gy|iz|Th",
                                          "type": "teamtag_get"
                                        }
                                      },
                                      "ARG6": {
                                        "block": {
                                          "fields": {
                                            "NUM": 1
                                          },
                                          "id": "HV@Sn2T0aLG~BXV_Ksy%",
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
                                    "id": "*+iRl7(o8TgjB9UWEAQg",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "id": ".1,baO$7yUS;f7#-@+(N",
                                          "inputs": {
                                            "DIVIDEND": {
                                              "block": {
                                                "fields": {
                                                  "OP": "MINUS"
                                                },
                                                "id": "-jPXvT%;0AtirvPh!8z(",
                                                "inputs": {
                                                  "A": {
                                                    "block": {
                                                      "fields": {
                                                        "THIS": false,
                                                        "VAR": "boardVariable:Tick"
                                                      },
                                                      "id": "q/nj.[J;)[1hm+FDNL)y",
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
                                                      "id": "T;M`d=kSIR:yz{3006Dp",
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
                                                "id": "Af;{`MCAj?xyCVWb7%F2",
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
                                          "id": "*e2S`%w(M.rMX2.lZ||I",
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
                              "id": "gwcKs^cB9OPzarABzYY^",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "OP": "MINUS"
                                    },
                                    "id": "^I|%3_n@4.w^-GcM`]sn",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "fields": {
                                            "THIS": false,
                                            "VAR": "boardVariable:Tick"
                                          },
                                          "id": ",k?Ni5e2-en$2p?gKgwG",
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
                                          "id": "xOm#1xt]^FEsSiGuoTx+",
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
                                    "id": "f4|}xUQ+k]L5m,8lzS^b",
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
                        "id": "qm{XmnFY[Wc2Qe$0cM-q",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "OP": "MINUS"
                              },
                              "id": "G8ZLsrXV?x:8WJDZ/Qs`",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "fields": {
                                      "THIS": false,
                                      "VAR": "boardVariable:Tick"
                                    },
                                    "id": "P_`P*Fb^sZ!;Ol8,f2$-",
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
                                    "id": "?azeBIF(F^b+fNZH2uN4",
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
                                "NUM": 217
                              },
                              "id": "fjDd4OUicp$}HJe4:Dw%",
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
                      "id": "MVGYJ3ikg;=ezC2E8[)r",
                      "inputs": {
                        "DO0": {
                          "block": {
                            "id": "eL|DR]p.rh6yhaBHx.G#",
                            "inputs": {
                              "DO0": {
                                "block": {
                                  "id": "t6{kN@f{YtXP=7;/MT1^",
                                  "inputs": {
                                    "DO0": {
                                      "block": {
                                        "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                        "fields": {
                                          "NAME": "boardMethod:AddUnit",
                                          "THIS": true
                                        },
                                        "id": "f.`Nr9},`9@k#1|La3/2",
                                        "inputs": {
                                          "ARG0": {
                                            "block": {
                                              "extraState": "<mutation></mutation>",
                                              "fields": {
                                                "TYPE": "board",
                                                "VAR": {
                                                  "id": "r@_Juggig!?i[d_kb*Pt"
                                                }
                                              },
                                              "id": "?CNu5CpL}J$v_ogoHoy1",
                                              "type": "variables_get"
                                            }
                                          },
                                          "ARG1": {
                                            "block": {
                                              "fields": {
                                                "VAR": "Location/SPAWNAREA_MOB_002"
                                              },
                                              "id": "9HySbPiq~v^*J!0/@m/r",
                                              "type": "stringkeys_get"
                                            }
                                          },
                                          "ARG4": {
                                            "block": {
                                              "fields": {
                                                "NUM": 0
                                              },
                                              "id": "u(-Ifb/F0r#Cv{_,[qCh",
                                              "type": "math_number"
                                            }
                                          },
                                          "ARG5": {
                                            "block": {
                                              "fields": {
                                                "VAR": "Enemy"
                                              },
                                              "id": "ds+)p-$)3r5jIIHA1SNv",
                                              "type": "teamtag_get"
                                            }
                                          },
                                          "ARG6": {
                                            "block": {
                                              "fields": {
                                                "NUM": 1
                                              },
                                              "id": "rb~nF/%f}@LiqzT@hp9+",
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
                                        "id": "%ArmuJx+djKc{)3G_qDz",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "id": "0w~:%C,^35W$z-x5ZgSf",
                                              "inputs": {
                                                "DIVIDEND": {
                                                  "block": {
                                                    "fields": {
                                                      "OP": "MINUS"
                                                    },
                                                    "id": "pBq`Rw+ImONTWG-2i`}%",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "fields": {
                                                            "THIS": false,
                                                            "VAR": "boardVariable:Tick"
                                                          },
                                                          "id": "Sz`K/9)[PLF^%,BamGCr",
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
                                                          "id": "kRLc4ID}Mj_vK5UJ(6A^",
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
                                                    "id": "2$4.JPu~=a,UPiktd~9^",
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
                                              "id": "i$#YJ$e;XctYrud6Wnvs",
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
                                  "id": "J_TZTI+^0OwG:`){I1a)",
                                  "inputs": {
                                    "A": {
                                      "block": {
                                        "fields": {
                                          "OP": "MINUS"
                                        },
                                        "id": "UJy#=zD9xF_b@QtNd3yh",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "THIS": false,
                                                "VAR": "boardVariable:Tick"
                                              },
                                              "id": "J5hWv0QnW|LJVa)Iu/un",
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
                                              "id": "YL@}J];*Z@$x*ZjTh$zT",
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
                                        "id": "*Fz!j!Yz_7?n,VQELzI9",
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
                            "id": "n0+E`g/GO2oHft?BDs{$",
                            "inputs": {
                              "A": {
                                "block": {
                                  "fields": {
                                    "OP": "MINUS"
                                  },
                                  "id": "ec5mLWbH@^*zAMH/P]Pp",
                                  "inputs": {
                                    "A": {
                                      "block": {
                                        "fields": {
                                          "THIS": false,
                                          "VAR": "boardVariable:Tick"
                                        },
                                        "id": "_@1SQm~qwcdb/$].M:In",
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
                                        "id": "}JZa@NvCq;=.o0Bm$+ui",
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
                                    "NUM": 645
                                  },
                                  "id": "V*%}Tjv*4Aela|U$-dYH",
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
                          "id": "a}XGegiw%$G#(YYU(mEm",
                          "inputs": {
                            "DO0": {
                              "block": {
                                "id": "G66tcb(+vn-rk+;EaIGu",
                                "inputs": {
                                  "DO0": {
                                    "block": {
                                      "id": "FZNCQ~5,a;oT)dLeRk#c",
                                      "inputs": {
                                        "DO0": {
                                          "block": {
                                            "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                            "fields": {
                                              "NAME": "boardMethod:AddUnit",
                                              "THIS": true
                                            },
                                            "id": "Idm;~C`[BY5OMvYN^BqZ",
                                            "inputs": {
                                              "ARG0": {
                                                "block": {
                                                  "extraState": "<mutation></mutation>",
                                                  "fields": {
                                                    "TYPE": "board",
                                                    "VAR": {
                                                      "id": "pQfRu:7w`Z}[8,?M{H`,"
                                                    }
                                                  },
                                                  "id": "c!T6;v,hqXBp9+D1zC(=",
                                                  "type": "variables_get"
                                                }
                                              },
                                              "ARG1": {
                                                "block": {
                                                  "fields": {
                                                    "VAR": "Location/SPAWNAREA_MOB_002"
                                                  },
                                                  "id": "GumHniy/R){a]Bvd-A50",
                                                  "type": "stringkeys_get"
                                                }
                                              },
                                              "ARG4": {
                                                "block": {
                                                  "fields": {
                                                    "NUM": 0
                                                  },
                                                  "id": "]x:g=Dfed4NU9/-jk*1}",
                                                  "type": "math_number"
                                                }
                                              },
                                              "ARG5": {
                                                "block": {
                                                  "fields": {
                                                    "VAR": "Enemy"
                                                  },
                                                  "id": "mRN8D3ZyRPT%C(rz:[o,",
                                                  "type": "teamtag_get"
                                                }
                                              },
                                              "ARG6": {
                                                "block": {
                                                  "fields": {
                                                    "NUM": 1
                                                  },
                                                  "id": "-G2b0]5!GsVPNtIS.{sr",
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
                                            "id": "PC$y*J6Bs?~Gdl9ShrzE",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "id": "*en#yE#?%E2D#$5B}T5A",
                                                  "inputs": {
                                                    "DIVIDEND": {
                                                      "block": {
                                                        "fields": {
                                                          "OP": "MINUS"
                                                        },
                                                        "id": "jY-_:el,bLGw_1{kw[*j",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "fields": {
                                                                "THIS": false,
                                                                "VAR": "boardVariable:Tick"
                                                              },
                                                              "id": "2#Tx23x:2ikatr@GRW0E",
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
                                                              "id": "Ctfe@T$PsTG1z8L1S]T0",
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
                                                          "NUM": 630
                                                        },
                                                        "id": "L{}?}@wxnxw:VEbg1jxt",
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
                                                  "id": "kE%GsHD.6.@^?ai[3.H,",
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
                                      "id": "9)ID))~V(?EC%.^_~=f0",
                                      "inputs": {
                                        "A": {
                                          "block": {
                                            "fields": {
                                              "OP": "MINUS"
                                            },
                                            "id": "dXaPo]?Hz=[,3o}{6{(A",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "fields": {
                                                    "THIS": false,
                                                    "VAR": "boardVariable:Tick"
                                                  },
                                                  "id": "D:Nv^C{s:q|.Wg+by6_N",
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
                                                  "id": "4tVI.}12Osc!sjYJqy@2",
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
                                            "id": "X2BBi1=Fxo[k{-;@vsfo",
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
                                "id": "/9/T1Y0SyL1nm?gZ:^^U",
                                "inputs": {
                                  "A": {
                                    "block": {
                                      "fields": {
                                        "OP": "MINUS"
                                      },
                                      "id": "v4V}|)DFYPfIe-Nu.:B[",
                                      "inputs": {
                                        "A": {
                                          "block": {
                                            "fields": {
                                              "THIS": false,
                                              "VAR": "boardVariable:Tick"
                                            },
                                            "id": "XVDMK%|p;`tpQ@eTH|E#",
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
                                            "id": "kn2bUA-3|Kh}Y.66ZE[P",
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
                                        "NUM": 435
                                      },
                                      "id": "!z25*n^IJ[~d6[l1$Qu,",
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
                              "id": "E!e6NJ9Bd,MAi$AdT=HY",
                              "inputs": {
                                "DO0": {
                                  "block": {
                                    "id": "G4~T_5DFga@:t6uF6+@n",
                                    "inputs": {
                                      "DO0": {
                                        "block": {
                                          "id": "f)$QPf`Q`I_vy5F[{${1",
                                          "inputs": {
                                            "DO0": {
                                              "block": {
                                                "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                "fields": {
                                                  "NAME": "boardMethod:AddUnit",
                                                  "THIS": true
                                                },
                                                "id": "EK?GZT;3#AbEmViOjPj6",
                                                "inputs": {
                                                  "ARG0": {
                                                    "block": {
                                                      "extraState": "<mutation></mutation>",
                                                      "fields": {
                                                        "TYPE": "board",
                                                        "VAR": {
                                                          "id": "r@_Juggig!?i[d_kb*Pt"
                                                        }
                                                      },
                                                      "id": "s{Tz]s`,LHdl^Q))8W/w",
                                                      "type": "variables_get"
                                                    }
                                                  },
                                                  "ARG1": {
                                                    "block": {
                                                      "fields": {
                                                        "VAR": "Location/SPAWNAREA_MOB_002"
                                                      },
                                                      "id": ")iV-@R]i5!h[bNtM,2sP",
                                                      "type": "stringkeys_get"
                                                    }
                                                  },
                                                  "ARG4": {
                                                    "block": {
                                                      "fields": {
                                                        "NUM": 0
                                                      },
                                                      "id": ":@V@|X^Ex2S]2zQwl`{z",
                                                      "type": "math_number"
                                                    }
                                                  },
                                                  "ARG5": {
                                                    "block": {
                                                      "fields": {
                                                        "VAR": "Enemy"
                                                      },
                                                      "id": "cj_M3*/KF)]Q)/b2C.,u",
                                                      "type": "teamtag_get"
                                                    }
                                                  },
                                                  "ARG6": {
                                                    "block": {
                                                      "fields": {
                                                        "NUM": 1
                                                      },
                                                      "id": "T[Q@fB1F`W//KpmeZKfl",
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
                                                "id": "-73/^l+H}ks1bge*=v@W",
                                                "inputs": {
                                                  "A": {
                                                    "block": {
                                                      "id": "VkPK6Ehe*gse{k5tuq?$",
                                                      "inputs": {
                                                        "DIVIDEND": {
                                                          "block": {
                                                            "fields": {
                                                              "OP": "MINUS"
                                                            },
                                                            "id": "T;u#~.u6coqf[Y@x@:NP",
                                                            "inputs": {
                                                              "A": {
                                                                "block": {
                                                                  "fields": {
                                                                    "THIS": false,
                                                                    "VAR": "boardVariable:Tick"
                                                                  },
                                                                  "id": ")D3hZ0Z-!Dz[ih*nMhZ}",
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
                                                                  "id": "flsa*=K[tyxcVMq0gx+~",
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
                                                            "id": ";+Re.p[sSc$md|idY;ca",
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
                                                        "NUM": 90
                                                      },
                                                      "id": "lxm^mTw7`Q;a/;*xfhj{",
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
                                          "id": "i9n%k)/;=Ouy]Cp*XpDN",
                                          "inputs": {
                                            "A": {
                                              "block": {
                                                "fields": {
                                                  "OP": "MINUS"
                                                },
                                                "id": "0{hYK`VGR6I~}oqyBz;S",
                                                "inputs": {
                                                  "A": {
                                                    "block": {
                                                      "fields": {
                                                        "THIS": false,
                                                        "VAR": "boardVariable:Tick"
                                                      },
                                                      "id": "F;pRrHn)_*/*h-hO32=!",
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
                                                      "id": "TfAfU+(g,{6S,S;l6|!I",
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
                                                "id": "sk*w}^pk|V/(^!q~V*4R",
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
                                    "id": "r.o:sAJHPBs9b~]a.]pK",
                                    "inputs": {
                                      "A": {
                                        "block": {
                                          "fields": {
                                            "OP": "MINUS"
                                          },
                                          "id": "Xl_-k1AP10|v?2:0RU]-",
                                          "inputs": {
                                            "A": {
                                              "block": {
                                                "fields": {
                                                  "THIS": false,
                                                  "VAR": "boardVariable:Tick"
                                                },
                                                "id": "J.hHz7wh2XitE50^LJL8",
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
                                                "id": "tgk2xC@McTYx|$hqo-$H",
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
                                            "NUM": 1140
                                          },
                                          "id": "NstzuC#$]Qg+y|MkB#N~",
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
                                  "id": "Ug.#=Am1J|PpojGs:!iR",
                                  "inputs": {
                                    "DO0": {
                                      "block": {
                                        "id": "vbBME4yyIDuwwRA=m@%#",
                                        "inputs": {
                                          "DO0": {
                                            "block": {
                                              "id": "TQX@1Hl9Vi.uteR]w_;B",
                                              "inputs": {
                                                "DO0": {
                                                  "block": {
                                                    "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                    "fields": {
                                                      "NAME": "boardMethod:AddUnit",
                                                      "THIS": true
                                                    },
                                                    "id": "=5br1`[p?CWw#51z2Wb(",
                                                    "inputs": {
                                                      "ARG0": {
                                                        "block": {
                                                          "extraState": "<mutation></mutation>",
                                                          "fields": {
                                                            "TYPE": "board",
                                                            "VAR": {
                                                              "id": "r@_Juggig!?i[d_kb*Pt"
                                                            }
                                                          },
                                                          "id": "I$u`.11(K2pN^Nz,i|RP",
                                                          "type": "variables_get"
                                                        }
                                                      },
                                                      "ARG1": {
                                                        "block": {
                                                          "fields": {
                                                            "VAR": "Location/SPAWNAREA_MOB_002"
                                                          },
                                                          "id": "iPC0xfEAeX6wve:LGh|=",
                                                          "type": "stringkeys_get"
                                                        }
                                                      },
                                                      "ARG4": {
                                                        "block": {
                                                          "fields": {
                                                            "NUM": 0
                                                          },
                                                          "id": "3*Z#9?iT4wfhWBj-n@)5",
                                                          "type": "math_number"
                                                        }
                                                      },
                                                      "ARG5": {
                                                        "block": {
                                                          "fields": {
                                                            "VAR": "Enemy"
                                                          },
                                                          "id": "Az#JbA:_wQ4RSRH#tiG=",
                                                          "type": "teamtag_get"
                                                        }
                                                      },
                                                      "ARG6": {
                                                        "block": {
                                                          "fields": {
                                                            "NUM": 1
                                                          },
                                                          "id": "Zd(N%IxOUu1@*=%`n8$,",
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
                                                    "id": "m4`ag7fv5l0rO56$op*^",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "id": "+9%VFb2LDuj2-Y|9hWt+",
                                                          "inputs": {
                                                            "DIVIDEND": {
                                                              "block": {
                                                                "fields": {
                                                                  "OP": "MINUS"
                                                                },
                                                                "id": "3(Z^G)QB!2!L3_Qw1RJI",
                                                                "inputs": {
                                                                  "A": {
                                                                    "block": {
                                                                      "fields": {
                                                                        "THIS": false,
                                                                        "VAR": "boardVariable:Tick"
                                                                      },
                                                                      "id": "qo-9IfnV$pms*Q@VSxUO",
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
                                                                      "id": "r9=?%5za8=s/EA~O|H%U",
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
                                                                "id": "bIt)|j!`N`Tnis5%}s]Z",
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
                                                            "NUM": 97
                                                          },
                                                          "id": "OJ*yOCD^R(i06|eBS`Ea",
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
                                              "id": "8SM`xoo5ZIkUtQDJDQdn",
                                              "inputs": {
                                                "A": {
                                                  "block": {
                                                    "fields": {
                                                      "OP": "MINUS"
                                                    },
                                                    "id": "U:=.7g7G^uJ$g5+s|Vg_",
                                                    "inputs": {
                                                      "A": {
                                                        "block": {
                                                          "fields": {
                                                            "THIS": false,
                                                            "VAR": "boardVariable:Tick"
                                                          },
                                                          "id": "r:VxnH]$nAAPFdc~BqoC",
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
                                                          "id": "V9^l]{_j-BSY#-akU._G",
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
                                                    "id": "O2(7I{kbA{+M]`p_q-iz",
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
                                        "id": "#-CttGjuNp_0ssJ1vvBE",
                                        "inputs": {
                                          "A": {
                                            "block": {
                                              "fields": {
                                                "OP": "MINUS"
                                              },
                                              "id": "USHqf.%E%ta6#AKz)i,f",
                                              "inputs": {
                                                "A": {
                                                  "block": {
                                                    "fields": {
                                                      "THIS": false,
                                                      "VAR": "boardVariable:Tick"
                                                    },
                                                    "id": "Jo/~dYfbWgYj!#r4)W/S",
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
                                                    "id": "j3H{lBr9uhcV`0@?rzra",
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
                                                "NUM": 1148
                                              },
                                              "id": ":^g1iWw.xdn|^I*UQPRK",
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
                                      "id": "oK-+5:`22C#852D#]~P#",
                                      "inputs": {
                                        "DO0": {
                                          "block": {
                                            "id": "pK3@e3m`Rl8A9tuB!{#d",
                                            "inputs": {
                                              "DO0": {
                                                "block": {
                                                  "id": "TVW;LD#9/A1u_~F8p/{{",
                                                  "inputs": {
                                                    "DO0": {
                                                      "block": {
                                                        "extraState": "<mutation itemCount=\"7\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Team.Enemy0)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
                                                        "fields": {
                                                          "NAME": "boardMethod:AddUnit",
                                                          "THIS": true
                                                        },
                                                        "id": "%CH-={hH8{uT]{FphtsS",
                                                        "inputs": {
                                                          "ARG0": {
                                                            "block": {
                                                              "extraState": "<mutation></mutation>",
                                                              "fields": {
                                                                "TYPE": "board",
                                                                "VAR": {
                                                                  "id": "U{CsAjq$Jq!y*JZY@-Yz"
                                                                }
                                                              },
                                                              "id": ")23kplXoYWp(2lN066cr",
                                                              "type": "variables_get"
                                                            }
                                                          },
                                                          "ARG1": {
                                                            "block": {
                                                              "fields": {
                                                                "VAR": "Location/SPAWNAREA_MOB_002"
                                                              },
                                                              "id": "yXkwqWC+p*ICa;@x}+0=",
                                                              "type": "stringkeys_get"
                                                            }
                                                          },
                                                          "ARG4": {
                                                            "block": {
                                                              "fields": {
                                                                "NUM": 0
                                                              },
                                                              "id": "Nm(H6st{p)M)i+zE{1k;",
                                                              "type": "math_number"
                                                            }
                                                          },
                                                          "ARG5": {
                                                            "block": {
                                                              "fields": {
                                                                "VAR": "Enemy"
                                                              },
                                                              "id": "7.j:D^WH}i/=uV*=qR`%",
                                                              "type": "teamtag_get"
                                                            }
                                                          },
                                                          "ARG6": {
                                                            "block": {
                                                              "fields": {
                                                                "NUM": 1
                                                              },
                                                              "id": ".M(|DGnJo:AS#Jc#_)g;",
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
                                                        "id": "^RGm*KC!zk!L_vdA//M2",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "id": "^_Jm*NX%{gR]j;AqB|7p",
                                                              "inputs": {
                                                                "DIVIDEND": {
                                                                  "block": {
                                                                    "fields": {
                                                                      "OP": "MINUS"
                                                                    },
                                                                    "id": ",zx?AuQRAjnv:peC@J2h",
                                                                    "inputs": {
                                                                      "A": {
                                                                        "block": {
                                                                          "fields": {
                                                                            "THIS": false,
                                                                            "VAR": "boardVariable:Tick"
                                                                          },
                                                                          "id": "ZUr{4~D*Nj^ezwznH0bK",
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
                                                                          "id": "Uy*iEOEn1d);@8^m=K|C",
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
                                                                      "NUM": 600
                                                                    },
                                                                    "id": "m`y8xM|jc`^f/L5utzIC",
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
                                                              "id": "~sn.IP$@ojW.@r1O2=k:",
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
                                                  "id": "BOd8U.(jE$H:VDsmpqtj",
                                                  "inputs": {
                                                    "A": {
                                                      "block": {
                                                        "fields": {
                                                          "OP": "MINUS"
                                                        },
                                                        "id": "a+c}1uxe3=EY%Bk0|H?7",
                                                        "inputs": {
                                                          "A": {
                                                            "block": {
                                                              "fields": {
                                                                "THIS": false,
                                                                "VAR": "boardVariable:Tick"
                                                              },
                                                              "id": ";c56-Sg8e?IJ|PM/v`p;",
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
                                                              "id": "qWkh)(cE$VVBq$vQD*V:",
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
                                                        "id": "cJOqFO[*_~J=W|h[VZ+T",
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
                                            "id": "bp7G7cw%Y/Cv`EbuG@~4",
                                            "inputs": {
                                              "A": {
                                                "block": {
                                                  "fields": {
                                                    "OP": "MINUS"
                                                  },
                                                  "id": "yN%yPRFTY|ep+G;:zW!2",
                                                  "inputs": {
                                                    "A": {
                                                      "block": {
                                                        "fields": {
                                                          "THIS": false,
                                                          "VAR": "boardVariable:Tick"
                                                        },
                                                        "id": "LivKeZz=ugm49Lwj#mgl",
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
                                                        "id": ")1%|{lUkqA{sx$GE:H[@",
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
                                                    "NUM": 750
                                                  },
                                                  "id": "SHg@Nrk@@s82/E5`v}$5",
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
          "IF0": {
            "block": {
              "fields": {
                "OP": "AND"
              },
              "id": "[2nM8?76;x{^Px}p7QUd",
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
                    "id": "K_|JK`c/`i?~FsTX=x~h",
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
                          "id": "t`g^sjiwUCpUa1jn@+i,",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 3
                          },
                          "id": "7%uL*9B*2V!!+i0m3gK0",
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
        "x": 1215,
        "y": 1515
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
                      "id": "(hmNBeg`XPQGB-!0e+7!",
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
                            "id": "vkRsy3!$%/`7S:^,n5N/",
                            "type": "variables_get"
                          }
                        },
                        "ARG1": {
                          "block": {
                            "fields": {
                              "NUM": 1
                            },
                            "id": "RZ.ma2OYo%-J^11flG@M",
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
                                "NAME": "Map_EncounterTraitWaveEnd",
                                "THIS": false
                              },
                              "id": "K)kU017[@0`f[Vnkb$@T",
                              "type": "trigger_call"
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
                                    "id": "En?L7bayWv(pxGV.f*DW"
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
                              "id": "F//i`5m5GJ/iAUoeO`l["
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
        "x": 1205,
        "y": 4875
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
                                      "id": "8n{`6@$tg,2A;R{Px}no"
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
                    "id": ";%F%|BT$Vv?,:P[6{(K0",
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
        "type": "controls_if",
        "x": 1215,
        "y": 5375
      },
      {
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
                                    "id": "8n{`6@$tg,2A;R{Px}no"
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
                        "id": ":n]+2AmHmLwW!roDGC7G"
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
        "type": "controls_if",
        "x": 1225,
        "y": 5955
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Map_New_Tutorial_Wave2",
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
      "id": "fMPyDKd!hVJz`=F+5pna",
      "name": "Zem"
    },
    {
      "id": "e)S4s=O{Cu=ZG;@~DYl^",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": ";3_FSB#@qOn~|-xFe)}m",
      "name": "Gem"
    },
    {
      "id": ";W@cn:WC09e}%8E]xKL3",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "MELJNwdH|Vh%8.,UoCq{",
      "name": "Map/Player/Moving"
    },
    {
      "id": "#@a$Y?BO@bTl5!kCv0|*",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "9OZ%#{4=TiY096`/dV}x",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "c7uR`zEXbFFnYn?/itBU",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "hVTs(m!KZ%rG0iA9?rDL",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "NREW6,Uiv#-?1z^IRP{2",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "?wq-HVtNg,N[7:s;;V_u",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "|@28TjOwPR.b;jU8iJIk",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "`LfBy`O5WsI#4r[_zi5@",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "o,RZ`aiWJU9[7qsOtxhD",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "5Edn1Z}|imv_)xU1]65S",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "-b+pICvgdzVbE,QB,]JK",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "vDeEys*lUaYRkG@mi%^Z",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "*fUv~GZwYX9ys$6TylnE",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "Nym:hA+H.$4^JGoySfBq",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "V~^mM=-y9yc#BKhd`ckl",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "BdiCX5)60bnsp2TJh=8@",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "h-SWTp`Cm}}W9XtC.Ctp",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "5hag{DFZBXr_7_o^rLHJ",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "0rVXZ60,YzwHD_ae^kk=",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "u~8pp1Sdpj:;fng!e;Ut",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "kx5:}3Gfo`.7S5-EWQ=7",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "@/dF@yUYUzZ$!+{how%8",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "b%^73O9I=H,qVH,b!~%h",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "M{y_(F4XXHdk]pdk@Ys}",
      "name": "@Map/Progress"
    },
    {
      "id": "j2f(]?5w-95xz(m=mfy?",
      "name": "Map/DisplayWinningTeam"
    },
    {
      "id": "7yf#U),8-_55DK2pr6^0",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "%ranxLR@D/.7|HqDcmy,",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "9Bu~0?gGlItswpQ[iy#b",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "3,h_ruon4$e(X;vUh9vF",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "M|Q:G2bVV+IHteGzSGxh",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "@~JmXzE(Qvh=f[g24F.:",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "8*XMLwfZ(z^VnP`E:Tq-",
      "name": "@Skill/Variable/10"
    }
  ]
}