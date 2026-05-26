{
  "blocks": {
    "blocks": [
      {
        "id": "?|6-YZD3;dbHn=(A_s9X",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "TYPE": "caller",
                "VAR": {
                  "id": "VwmPw+Go:-Dax{ZYx^QU"
                }
              },
              "id": "o+,4JHCZ:K2sgw1seHeL",
              "inputs": {
                "VALUE": {
                  "block": {
                    "fields": {
                      "NUM": 0
                    },
                    "id": "|v[zX+UDt7YgPo05)Ui/",
                    "type": "math_number"
                  }
                }
              },
              "next": {
                "block": {
                  "fields": {
                    "TYPE": "caller",
                    "VAR": {
                      "id": "]0zu%je|1A@@Ln|jk-#p"
                    }
                  },
                  "id": "Z,okpl^B=XilIvf6Ykc1",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "BOOL": "TRUE"
                        },
                        "id": "R)W80u`%5BQ^/n;lGi%[",
                        "type": "logic_boolean"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "fields": {
                        "TYPE": "caller",
                        "VAR": {
                          "id": "BTB(VV*%O$b%J?C)=e!5"
                        }
                      },
                      "id": "_ByM~sQ.)[RDe*Iwx)33",
                      "inputs": {
                        "VALUE": {
                          "block": {
                            "fields": {
                              "OP": "MINUS"
                            },
                            "id": "SczzCql/VoT1K]PDU,=a",
                            "inputs": {
                              "A": {
                                "block": {
                                  "fields": {
                                    "THIS": true,
                                    "VAR": "unitVariable:DataId"
                                  },
                                  "id": ",(f8gH8!Tp8|Xx_ySGpr",
                                  "type": "variables_get_reserved"
                                },
                                "shadow": {
                                  "fields": {
                                    "NUM": 1
                                  },
                                  "id": "A=F*3(Y+!.Do#@G}zf$:",
                                  "type": "math_number"
                                }
                              },
                              "B": {
                                "block": {
                                  "id": "N;wJ@bT5?i{UnFXL]LcT",
                                  "inputs": {
                                    "DIVIDEND": {
                                      "block": {
                                        "fields": {
                                          "THIS": true,
                                          "VAR": "unitVariable:DataId"
                                        },
                                        "id": "A8ObR=#RTNo0m@!j%zC_",
                                        "type": "variables_get_reserved"
                                      },
                                      "shadow": {
                                        "fields": {
                                          "NUM": 64
                                        },
                                        "id": "(2i*ffv=#%zO;5s20Zw]",
                                        "type": "math_number"
                                      }
                                    },
                                    "DIVISOR": {
                                      "shadow": {
                                        "fields": {
                                          "NUM": 100
                                        },
                                        "id": "FF$+jRm?sbOvWGJHg:h.",
                                        "type": "math_number"
                                      }
                                    }
                                  },
                                  "type": "math_modulo"
                                },
                                "shadow": {
                                  "fields": {
                                    "NUM": 10
                                  },
                                  "id": "yuBpHn_R|oZ|=f/=$V;i",
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
                            "TYPE": "caller",
                            "VAR": {
                              "id": "BTB(VV*%O$b%J?C)=e!5"
                            }
                          },
                          "id": ")6/tSTJ)kc2CWMZy_$y9",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "OP": "ADD"
                                },
                                "id": "Y!-e5Rv$*URCdwQA.3lU",
                                "inputs": {
                                  "A": {
                                    "block": {
                                      "fields": {
                                        "OP": "MULTIPLY"
                                      },
                                      "id": "zU3g*6@IJ4+d8iSu|[={",
                                      "inputs": {
                                        "A": {
                                          "block": {
                                            "extraState": "<mutation></mutation>",
                                            "fields": {
                                              "TYPE": "caller",
                                              "VAR": {
                                                "id": "BTB(VV*%O$b%J?C)=e!5"
                                              }
                                            },
                                            "id": "?brc.KLtst1$i3ZSO;QV",
                                            "type": "variables_get"
                                          },
                                          "shadow": {
                                            "fields": {
                                              "NUM": 1
                                            },
                                            "id": "[Mu^F8SbUxdbz{Z[I(P%",
                                            "type": "math_number"
                                          }
                                        },
                                        "B": {
                                          "shadow": {
                                            "fields": {
                                              "NUM": 10
                                            },
                                            "id": "S[VZJ^H^XxQ^[!9}mSmW",
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
                                      "id": "mTM:dpWNDKU6N(6z4[p/",
                                      "type": "math_number"
                                    }
                                  },
                                  "B": {
                                    "shadow": {
                                      "fields": {
                                        "NUM": 11
                                      },
                                      "id": "tZyBfh3__lVXCnqA9@0L",
                                      "type": "math_number"
                                    }
                                  }
                                },
                                "type": "math_arithmetic"
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
          "IF0": {
            "block": {
              "fields": {
                "OP": "EQ"
              },
              "id": "xMT!iC/]`7fcDU;q{~BP",
              "inputs": {
                "A": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "]0zu%je|1A@@Ln|jk-#p"
                      }
                    },
                    "id": "Qxz!SlgO~X-~H!Z2Z$Cm",
                    "type": "variables_get"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "BOOL": "FALSE"
                    },
                    "id": "0^to3Z3,lxUzvK]FT|G6",
                    "type": "logic_boolean"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "next": {
          "block": {
            "extraState": {
              "hasElse": true
            },
            "id": "miSo~;1ky|zngj(erW7W",
            "inputs": {
              "DO0": {
                "block": {
                  "extraState": {
                    "hasElse": true
                  },
                  "id": "0{MBGts=+.VBAbD|l,z3",
                  "inputs": {
                    "DO0": {
                      "block": {
                        "extraState": {
                          "hasElse": true
                        },
                        "id": "y3^`a]5p}QqwS:%{Ar+Z",
                        "inputs": {
                          "DO0": {
                            "block": {
                              "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                              "fields": {
                                "NAME": "unitMethod:Stop",
                                "THIS": true
                              },
                              "id": "wA!Y]KP}X1K6^}ag]MC`",
                              "next": {
                                "block": {
                                  "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                                  "fields": {
                                    "NAME": "unitMethod:LookAtTarget",
                                    "THIS": true
                                  },
                                  "id": ".qgSN/gxWNa9dSL6X=6v",
                                  "next": {
                                    "block": {
                                      "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;}]\"></mutation>",
                                      "fields": {
                                        "NAME": "unitMethod:UseSkill",
                                        "THIS": true
                                      },
                                      "id": "!1mY@v6TL;nwfBj{oBcd",
                                      "inputs": {
                                        "ARG0": {
                                          "block": {
                                            "fields": {
                                              "NUM": 101011
                                            },
                                            "id": "[c1b]{La0zd#rw=va-[P",
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
                              "type": "function_call"
                            }
                          },
                          "ELSE": {
                            "block": {
                              "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                              "fields": {
                                "NAME": "unitMethod:LookAtTarget",
                                "THIS": true
                              },
                              "id": ":^w6Ni(Ama5Qq!fsQwml",
                              "type": "function_call"
                            }
                          },
                          "IF0": {
                            "block": {
                              "fields": {
                                "OP": "EQ"
                              },
                              "id": "o)s3fCRcaYg5H/2zX{m]",
                              "inputs": {
                                "A": {
                                  "block": {
                                    "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;}]\"></mutation>",
                                    "fields": {
                                      "NAME": "unitMethod:GetSkillCooldown",
                                      "THIS": true
                                    },
                                    "id": "_}diOhLj!Fru2W`bpp@T",
                                    "inputs": {
                                      "ARG0": {
                                        "block": {
                                          "fields": {
                                            "NUM": 101011
                                          },
                                          "id": "50m3D8xdquR`Sck9zDL_",
                                          "type": "math_number"
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
                                    "id": "hxo+69MRSZ]o-riJ@o{6",
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
                    "ELSE": {
                      "block": {
                        "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                        "fields": {
                          "NAME": "unitMethod:LookAtTarget",
                          "THIS": true
                        },
                        "id": "jqDk},Aoj2$as$~^2Q,k",
                        "next": {
                          "block": {
                            "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;}]\"></mutation>",
                            "fields": {
                              "NAME": "unitMethod:SetMoveDirection",
                              "THIS": true
                            },
                            "id": "WN4uC4vcK+%`pHAtErRU",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "fields": {
                                    "THIS": true,
                                    "VAR": "unitVariable:TargetAngle"
                                  },
                                  "id": "o2v?M`UQVq#y2Z`FdZHi",
                                  "type": "variables_get_reserved"
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
                          "OP": "LTE"
                        },
                        "id": "=d-Sv[49#}2x#;;?_)@f",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "THIS": true,
                                "VAR": "unitVariable:TargetDistance"
                              },
                              "id": "v2T?%j7cGBe[MVsVT}e(",
                              "type": "variables_get_reserved"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "NUM": 5
                              },
                              "id": "@oxR87D#0^F~K/A0Hir=",
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
              "ELSE": {
                "block": {
                  "id": "uMkb/V4Y?G}lqEx-g;Zu",
                  "inputs": {
                    "DO0": {
                      "block": {
                        "fields": {
                          "TYPE": "caller",
                          "VAR": {
                            "id": "VwmPw+Go:-Dax{ZYx^QU"
                          }
                        },
                        "id": "57%X4cf0,ykv}).S9ERE",
                        "inputs": {
                          "VALUE": {
                            "block": {
                              "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;최솟값 (필수)&quot;,&quot;name&quot;:&quot;Min&quot;},{&quot;comment&quot;:&quot;최댓값 (필수)&quot;,&quot;name&quot;:&quot;Max&quot;}]\"></mutation>",
                              "fields": {
                                "NAME": "boardMethod:RandomIntBetween",
                                "THIS": true
                              },
                              "id": "|?pi.n2jS1yTh[a1DSCm",
                              "inputs": {
                                "ARG0": {
                                  "block": {
                                    "fields": {
                                      "NUM": 4
                                    },
                                    "id": "6qmY`i9?%8.3pC=^E~_w",
                                    "type": "math_number"
                                  }
                                },
                                "ARG1": {
                                  "block": {
                                    "fields": {
                                      "NUM": 8
                                    },
                                    "id": "0YEWMC^Y@|LOjX1o(NAP",
                                    "type": "math_number"
                                  }
                                }
                              },
                              "type": "function_call_return"
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
                        "id": "cmAwwsC?t;[O-F=fO6(c",
                        "inputs": {
                          "A": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "caller",
                                "VAR": {
                                  "id": "VwmPw+Go:-Dax{ZYx^QU"
                                }
                              },
                              "id": "{hvO#4G@lj-}ZD7SA*!A",
                              "type": "variables_get"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "NUM": 0
                              },
                              "id": "z8[9Ge8w.={AORHV3s4.",
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
                      "extraState": {
                        "hasElse": true
                      },
                      "id": "-o/G0.7[.BzN7FTWU2%B",
                      "inputs": {
                        "DO0": {
                          "block": {
                            "extraState": "<mutation itemCount=\"4\" metadata=\"[{&quot;comment&quot;:&quot;Position X (필수)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y (필수)&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Position X max range (필수)&quot;,&quot;name&quot;:&quot;PositionXRange&quot;},{&quot;comment&quot;:&quot;Position Y max range (필수)&quot;,&quot;name&quot;:&quot;PositionYRange&quot;}]\"></mutation>",
                            "fields": {
                              "NAME": "unitMethod:SetMoveRandomDestination",
                              "THIS": true
                            },
                            "id": "+Ay-pA-@jb{eR3Q:%P:|",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "fields": {
                                    "THIS": true,
                                    "VAR": "unitVariable:PositionX"
                                  },
                                  "id": "zz2G2:Ld-T12RnQn5li2",
                                  "type": "variables_get_reserved"
                                }
                              },
                              "ARG1": {
                                "block": {
                                  "fields": {
                                    "THIS": true,
                                    "VAR": "unitVariable:PositionY"
                                  },
                                  "id": "r{b7V{tvNTPu1ccp%F0e",
                                  "type": "variables_get_reserved"
                                }
                              },
                              "ARG2": {
                                "block": {
                                  "fields": {
                                    "NUM": 2
                                  },
                                  "id": "}A_#y#)GwB|Ky3Ny;p@D",
                                  "type": "math_number"
                                }
                              },
                              "ARG3": {
                                "block": {
                                  "fields": {
                                    "NUM": 2
                                  },
                                  "id": "4vhiAF|ue=AKDA=W:kFw",
                                  "type": "math_number"
                                }
                              }
                            },
                            "next": {
                              "block": {
                                "fields": {
                                  "TYPE": "caller",
                                  "VAR": {
                                    "id": ")rPphoqQ;#^gJU/-@`1!"
                                  }
                                },
                                "id": "l@pa{8jd=ZdSFNFGGGd(",
                                "inputs": {
                                  "VALUE": {
                                    "block": {
                                      "fields": {
                                        "NUM": 0
                                      },
                                      "id": "orD^Z~6~J{eEQ?u:xWQM",
                                      "type": "math_number"
                                    }
                                  }
                                },
                                "next": {
                                  "block": {
                                    "fields": {
                                      "TYPE": "caller",
                                      "VAR": {
                                        "id": "VwmPw+Go:-Dax{ZYx^QU"
                                      }
                                    },
                                    "id": "hl6wQy[K5XqwGgUyesMh",
                                    "inputs": {
                                      "VALUE": {
                                        "block": {
                                          "fields": {
                                            "NUM": 0
                                          },
                                          "id": "tTa|%fm_5@~)nV`XplP1",
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
                        "ELSE": {
                          "block": {
                            "fields": {
                              "TYPE": "caller",
                              "VAR": {
                                "id": ")rPphoqQ;#^gJU/-@`1!"
                              }
                            },
                            "id": "kux6RITgTlsx|CdPW2c|",
                            "inputs": {
                              "VALUE": {
                                "block": {
                                  "fields": {
                                    "OP": "ADD"
                                  },
                                  "id": "pD8E-7H|1rsp~/c(eU?G",
                                  "inputs": {
                                    "A": {
                                      "block": {
                                        "extraState": "<mutation></mutation>",
                                        "fields": {
                                          "TYPE": "caller__unit",
                                          "VAR": {
                                            "id": ")rPphoqQ;#^gJU/-@`1!"
                                          }
                                        },
                                        "id": "t)[g9p-5v=[=%R:@-rvv",
                                        "type": "variables_get"
                                      },
                                      "shadow": {
                                        "fields": {
                                          "NUM": 1
                                        },
                                        "id": "f~L1/gkNvE,eey5?R@4g",
                                        "type": "math_number"
                                      }
                                    },
                                    "B": {
                                      "shadow": {
                                        "fields": {
                                          "NUM": 1
                                        },
                                        "id": "YKm]C!cp#uF{*0_vQKW9",
                                        "type": "math_number"
                                      }
                                    }
                                  },
                                  "type": "math_arithmetic"
                                }
                              }
                            },
                            "type": "variables_set"
                          }
                        },
                        "IF0": {
                          "block": {
                            "fields": {
                              "OP": "GT"
                            },
                            "id": "U!]IF{@#rN/xS6QCNRP2",
                            "inputs": {
                              "A": {
                                "block": {
                                  "extraState": "<mutation></mutation>",
                                  "fields": {
                                    "TYPE": "caller",
                                    "VAR": {
                                      "id": ")rPphoqQ;#^gJU/-@`1!"
                                    }
                                  },
                                  "id": "LGqx[LJ-y3g2gfw)I1/(",
                                  "type": "variables_get"
                                }
                              },
                              "B": {
                                "block": {
                                  "extraState": "<mutation></mutation>",
                                  "fields": {
                                    "TYPE": "caller",
                                    "VAR": {
                                      "id": "VwmPw+Go:-Dax{ZYx^QU"
                                    }
                                  },
                                  "id": "l.M$D;8zQx`Q/4}z7(m=",
                                  "type": "variables_get"
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
              "IF0": {
                "block": {
                  "fields": {
                    "OP": "EQ"
                  },
                  "id": "I8L!x.A[iZ4`j$w`c|Pm",
                  "inputs": {
                    "A": {
                      "block": {
                        "fields": {
                          "THIS": true,
                          "VAR": "unitVariable:HasTarget"
                        },
                        "id": "42+pP05Lu)(!^MOmI{::",
                        "type": "variables_get_reserved"
                      }
                    },
                    "B": {
                      "block": {
                        "fields": {
                          "BOOL": "TRUE"
                        },
                        "id": "fR8#a+N8a`u$aB!C}Afx",
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
        "type": "controls_if",
        "x": 375,
        "y": 325
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Unit_Monster_BearKing",
    "period": "15",
    "triggerType": "1"
  },
  "scroll": {},
  "variables": [
    {
      "id": ")rPphoqQ;#^gJU/-@`1!",
      "name": "Unit/Tick"
    },
    {
      "id": "Ofk!Q:x.#eMsU9X,t-)D",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "]0zu%je|1A@@Ln|jk-#p",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "VwmPw+Go:-Dax{ZYx^QU",
      "name": "Unit/Rome"
    },
    {
      "id": "BTB(VV*%O$b%J?C)=e!5",
      "name": "Unit/DefaultSkillID01"
    },
    {
      "id": "kPaw8dxLKsavFF1dmB:)",
      "name": "Unit/DefaultSkillID02"
    },
    {
      "id": "L8`Wv?6A!AQFv7#J!n-8",
      "name": "Unit/Time01"
    },
    {
      "id": "Y.hY7f_?fjO`OP/.m_.T",
      "name": "Unit/Time02"
    },
    {
      "id": "mgFb.rayoh4}o$z=P2n(",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "}9Yse]cH-$S}3;+B;mMB",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "X4?Kg|PC4..4B2/kMQR.",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "oj{N,nh-Y*CGvQDpniPB",
      "name": "@Unit/Delay"
    },
    {
      "id": "*eWhr=t3L@AlkqoJB+G%",
      "name": "@Unit/Range"
    },
    {
      "id": "@AO~*FN/]tw:98TYeR8f",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "?wULTqsiba*yT0.Ov$+A",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "}-2evA,q%W87F7Uz#O_F",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "ZH=gN.+}MEV/JQBGS@Q$",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "X!N+t_Y#OLnYtTyg!3,V",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "oLLMru6iyGf$)g8Kv)iv",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "Qt,[mu*wfJS8rhjHG[WW",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "@)FOnX!_FD(G{upwwL=[",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "){%l10-7Dmps6^dPOV}O",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "Qqk^t5hGkoYpV-13N+Wb",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "pqgcy{cgc-2hOr+wk=_F",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "!n$_2nc`$/}[X$s`t:vr",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "E+B3?m+!hCU6In3.U,-E",
      "name": "@Unit/Range01"
    },
    {
      "id": "B:H`k9ajB@NQ6Z@MV59F",
      "name": "@Unit/Range02"
    },
    {
      "id": "3*:{e]}6)jCk%+$l1XDL",
      "name": "@Unit/Range03"
    },
    {
      "id": "R?A_Po%bBRN7B2Sc,DLZ",
      "name": "@Unit/Range04"
    },
    {
      "id": "Za9US_Kv!drZ2x=MhlMW",
      "name": "@Unit/Range05"
    },
    {
      "id": "-5kn|ez:l+V~TM9nsl6J",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "O}[YAszrPF[!b_]N5Ngz",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": "qyb^::JsyT@YM3r7NOe+",
      "name": "@Map/MonsterID01"
    },
    {
      "id": "TPFZs1%x+u0O9CcmM5+3",
      "name": "@Map/MonsterID02"
    },
    {
      "id": ")cyU#0oL`XdAG5XR:0R0",
      "name": "@Map/MonsterID03"
    },
    {
      "id": "09!Ot-%-}po+lI1_?T0k",
      "name": "@Map/MonsterID04"
    },
    {
      "id": "jL=8`^nK)Xy?2.UW-!F@",
      "name": "@Map/MonsterID05"
    },
    {
      "id": "5M|xoKROTalGMRbBH:5d",
      "name": "@Map/MonsterID06"
    },
    {
      "id": "YJIDM?0mv|}}DIQi[7kV",
      "name": "@Map/MonsterID07"
    },
    {
      "id": ";CI}3z}vW`9HAOHTyHFe",
      "name": "@Map/MonsterID08"
    },
    {
      "id": "D9h^()P{@OMPsDUmHkXx",
      "name": "@Map/MonsterID09"
    },
    {
      "id": "t^fX7_,VXE!V{+y}f_B2",
      "name": "@Map/MonsterID10"
    },
    {
      "id": "Nqf+;De^1^O3pFZ}QMY_",
      "name": "@Map/MonsterID11"
    },
    {
      "id": "?LsWWhV~?6Mr}3`wJ7^Z",
      "name": "@Map/MonsterID12"
    },
    {
      "id": "8%%x4So/P??8xg6-w]Vx",
      "name": "@Map/MonsterID13"
    },
    {
      "id": "B82h1l/*3wp9Nq]Z|o:r",
      "name": "@Map/MonsterID14"
    },
    {
      "id": "!uxC~+ho}`F)2Q1`?T2h",
      "name": "@Map/MonsterID15"
    },
    {
      "id": "pLuY1l9xGt%GzHZ)S|d?",
      "name": "@Map/MonsterID16"
    },
    {
      "id": "y-~bt?an#^hmQZSi|F$Q",
      "name": "@Map/MonsterID17"
    },
    {
      "id": "IAKJU]DY^c}}m0;[W%2Z",
      "name": "@Map/MonsterID18"
    },
    {
      "id": "LFuYKj6l8-h.xJ~GmHPL",
      "name": "@Map/MonsterID19"
    },
    {
      "id": "JC;zs[A!4_GuY5l/.C^*",
      "name": "@Map/MonsterID20"
    },
    {
      "id": "LMjDpOdlU_e_x%F}eC4c",
      "name": "@Map/MonsterID21"
    },
    {
      "id": "nLm}J2/]Em0xd@5qQ*@?",
      "name": "@Map/MonsterID22"
    },
    {
      "id": "c@MvG[[1WNK!:X0PM?i_",
      "name": "@Map/MonsterID23"
    },
    {
      "id": "@J5{1)R_2YVZjBL(2/Q]",
      "name": "@Map/MonsterID24"
    },
    {
      "id": "n5Zjp/P`phU@aQWsyOtm",
      "name": "@Map/MonsterID25"
    },
    {
      "id": "wq3Wz,ly4-QH,/R}Mpsz",
      "name": "@Map/MonsterID26"
    },
    {
      "id": "h!iI%`/3_RQ:a/LA=ju2",
      "name": "@Map/MonsterID27"
    },
    {
      "id": "Os:U78Io]W4+Blp7LhE9",
      "name": "@Map/MonsterID28"
    },
    {
      "id": "HsjtelL,A9FM=VxP-:-=",
      "name": "@Map/MonsterID29"
    },
    {
      "id": ".,V),bhtI,u8^$z0-mus",
      "name": "@Map/MonsterID30"
    },
    {
      "id": "MJ)05Qq0J;QSM:Qppop/",
      "name": "@Map/MonsterID31"
    },
    {
      "id": "UFU7w!{st.Cr_/.#cFci",
      "name": "@Map/MonsterID32"
    },
    {
      "id": "y(Q``OWOz+e@XUJP+e_[",
      "name": "@Map/MonsterID33"
    },
    {
      "id": "#=,_D/c-V=HZ$Hj9X7Xs",
      "name": "@Map/MonsterID34"
    },
    {
      "id": "AJ%DdQ]qw95_!uA.Os0v",
      "name": "@Map/MonsterID35"
    },
    {
      "id": "`Xbt,S=SxJ0_ZT3,X^AS",
      "name": "@Map/MonsterID36"
    },
    {
      "id": "l1CL+9%o[%N?0}`DbLoW",
      "name": "@Map/MonsterID37"
    },
    {
      "id": "}[B_w2QKbwM7_L}mwSP`",
      "name": "@Map/MonsterID38"
    },
    {
      "id": "0|DEUYAbjj6uK6HO]Pam",
      "name": "@Map/MonsterID39"
    },
    {
      "id": "[W+XG!CWr2QBgShFDSSP",
      "name": "@Map/MonsterID40"
    },
    {
      "id": "jgr:)$3GRZ#zqMfc+W2e",
      "name": "@Map/MonsterID41"
    },
    {
      "id": "bz3I*a}8(b,Z;%G/(Fo{",
      "name": "@Map/MonsterID42"
    },
    {
      "id": "X+@iqGNvZC29+b(J);NZ",
      "name": "@Map/MonsterID43"
    },
    {
      "id": "}KG:02wKf@{4J}VkVy=P",
      "name": "@Map/MonsterID44"
    },
    {
      "id": "1d^qcf@#L[QK%m(H6a_4",
      "name": "@Map/MonsterID45"
    },
    {
      "id": "wj*^x;jtrC{df41@{04l",
      "name": "@Map/MonsterID46"
    },
    {
      "id": "6=rc]..C232.ph1#X,@:",
      "name": "@Map/MonsterID47"
    },
    {
      "id": "/xZ2L=7pP7,~[k6:fEkN",
      "name": "@Map/MonsterID48"
    },
    {
      "id": "{y.JjnVf3d0k$-peyzwc",
      "name": "@Map/MonsterID49"
    },
    {
      "id": "dQ8SbMayQh8:sc[DO@$v",
      "name": "@Map/MonsterID50"
    },
    {
      "id": "NIxG)(z~)p7!jx4p2:E:",
      "name": "@Map/MonsterID51"
    },
    {
      "id": "/8D1]c}F*u6AZ%]h}wKo",
      "name": "@Map/MonsterID52"
    },
    {
      "id": ".N(TS=5$AZQB?J#Qs*LH",
      "name": "@Map/MonsterID53"
    },
    {
      "id": "L;fD/9fHVeeu{*qA5_aQ",
      "name": "@Map/MonsterID54"
    },
    {
      "id": "24@PSFxiAV!sW|FRS`lr",
      "name": "@Map/MonsterID55"
    },
    {
      "id": "PTFn*DNwu|5]Mt4r4L=G",
      "name": "@Map/MonsterID56"
    },
    {
      "id": "~(Qe-EzGYR@1)/;fG1_5",
      "name": "@Map/MonsterID57"
    },
    {
      "id": "7d=;dqcaJp,+qC2N^)]K",
      "name": "@Map/MonsterID58"
    },
    {
      "id": "II#4Z9RI_[woLkch~WOo",
      "name": "@Map/MonsterID59"
    },
    {
      "id": "RZ-yfcmp;rBY@g`a`*~`",
      "name": "@Map/MonsterID60"
    },
    {
      "id": "3sMK9HPL2NMQms;j5lfq",
      "name": "@Map/AddBuffID01"
    },
    {
      "id": "3Fse%FGo$oRu|S*h51yw",
      "name": "@Map/AddBuffID02"
    },
    {
      "id": "K0w~ofBD*`Fz2:*~_MK2",
      "name": "@Map/AddBuffID03"
    },
    {
      "id": "mpWri*E!B^Y7PW;-X7aL",
      "name": "@Map/AddBuffID04"
    },
    {
      "id": "b?PTr:Im}!4VV9tMNeC;",
      "name": "@Map/AddBuffID05"
    },
    {
      "id": "bW1Zf$5F@/Fo]-#?`z/J",
      "name": "@Map/AddBuffID06"
    },
    {
      "id": "70~+ci{Y6il?sK}9#v[R",
      "name": "@Map/AddBuffID07"
    },
    {
      "id": "X|*1./D}7NC8,b@N^z1=",
      "name": "@Map/AddBuffID08"
    },
    {
      "id": ",[hV|!0Sf8,8(;ral9U.",
      "name": "@Map/AddBuffID09"
    },
    {
      "id": "S75fZ,~F|3Yl[f6U2+tB",
      "name": "@Map/AddBuffID10"
    },
    {
      "id": "eP~AFJHQ7-fNSYb[/p9.",
      "name": "@Map/AddBuffID11"
    },
    {
      "id": "KP/+/W}kdS~/IDAik^Vo",
      "name": "@Map/AddBuffID12"
    },
    {
      "id": "f#2G^QZOZA:[=.0OWLRz",
      "name": "@Map/AddBuffID13"
    },
    {
      "id": "]i}rPvy=O@GgR@rd|RZt",
      "name": "@Map/AddBuffID14"
    },
    {
      "id": "$H}i~YPp#vNSCNrRrE?*",
      "name": "@Map/AddBuffID15"
    },
    {
      "id": "u=Z2kKhoa$EH5-`OZ~4[",
      "name": "@Map/AddBuffID16"
    },
    {
      "id": "U~I-UTe)%`(?7pGx[n_9",
      "name": "@Map/AddBuffID17"
    },
    {
      "id": "+(DPh|8I)8~62jcwNT]1",
      "name": "@Map/AddBuffID18"
    },
    {
      "id": "@4/k+dx5vxv?N_z-stB$",
      "name": "@Map/AddBuffID19"
    },
    {
      "id": "uP7JV*Xa_uW1z|ZpfN+V",
      "name": "@Map/AddBuffID20"
    },
    {
      "id": "u,O*d7wqSwsO_xKJ`[E|",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "ltnMB)Jc2d43dF565F0D",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "0zIbj}Bd)/LnS#E#2d)m",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "qcaSzYhuB)kY519]/g0s",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "_K^`0~HU4M@MKF?x9?nB",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "M.ylAz*00BH{l6:D:$,5",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "QX9O5:1p*+x(hG,?JW(L",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "yVmvVgA3AR^yC/Xs#4EF",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "r,PwdeeDI~M_apr3/doj",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "ZJ:^IpE_wkX!/}D:%WIN",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "IS.Hop(;$eeDyD/R|lCD",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "n-LXiJ]ktw.SpClClcQ;",
      "name": "Map/BattleValue"
    },
    {
      "id": "9H+zbQ#ZO1iZ8YC/q7*P",
      "name": "Map/IsClear"
    },
    {
      "id": "?L1db/0`kGLkw9^xa{#d",
      "name": "Map/WaveCount"
    },
    {
      "id": "}__-E*I+aR_S,@Bn,Pe-",
      "name": "Map/WaveTick"
    },
    {
      "id": "^/tOTGl[|wCqO*i)*Roj",
      "name": "Map/IsSpawn"
    },
    {
      "id": "Ek,2olT)=u~7{6w(/R+|",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "3+n473]S^J__#f?gpJ*.",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "jMK2q!#DKxit_RP+qyc9",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "QbM*n9iMo{0QCFU6()@X",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "(0?Rk~Yr^.5zwLtd=|1^",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "1RWqxudQ14RvONB|vp9`",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "[3Q+(wTG_Z_(Rg,T)s]h",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "+FuCV-_`}UdoY`102#$@",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "Db]%Y;!5-kj@,i5V|HvV",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "MMOQ#:JdK4tM~FkBL?@w",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "CO4zbH[kPb`@/vYAlF@Q",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": ";FMO_k4aQ?N!}/6j,wyr",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "aj]$|SAzrc0L%Z]([)r/",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": ";#TCT?/x@.vMit/R.5Co",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "1|$z7LtfjR%6b${c6e%(",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "W40lwT$53NXi2|acN:uO",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "chIQ_kkF[kAomHO7CvOT",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "DiHatqrn^U_Ln?H0zt`A",
      "name": "Gem"
    },
    {
      "id": "0Y`p%(#ZjVc)}?}sci.?",
      "name": "@Unit/Variable01"
    },
    {
      "id": "o]%5BHW?z$z|H#7Cw4X0",
      "name": "@Unit/Variable02"
    },
    {
      "id": "?:c6hB(yYP:jm^nmhExR",
      "name": "@Unit/Variable03"
    },
    {
      "id": "tmF-?[6Qqpz*Y}0ztpa8",
      "name": "@Unit/Variable04"
    },
    {
      "id": "2UXKzheH(S!K(CoSg=cX",
      "name": "@Unit/Variable05"
    },
    {
      "id": "5/dosyys{Fw#el8UZt:J",
      "name": "@Map/Variable01"
    },
    {
      "id": "+PzG4h;+gRj#qB*02UEH",
      "name": "@Map/Variable02"
    },
    {
      "id": "hF$+{RX3m*P@sk1Eujwb",
      "name": "@Map/Variable03"
    },
    {
      "id": "N6gs8},~+)QZx{f{i[oV",
      "name": "@Map/Variable04"
    },
    {
      "id": "sstBh%5!#ce/DkJ=J6Hw",
      "name": "@Map/Variable05"
    },
    {
      "id": "N)6vx_T?)s8p_(;rs0A{",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "]qi1^.;N73zP:y*_Q/*r",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "|gn]OtnYJiH%@97!p%PI",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "Vc-{o:6Ttxj(Co)A,YTv",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "kWM?(%=r``bHXiV.a]N(",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "y}Cq6SPCNG8k]L@WOR%]",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "[`$MVA.:.Jnzk%5Z=|%R",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "=iE=2KSUM|{SL0oCGnOI",
      "name": "Map/Wave"
    },
    {
      "id": ",5D`+~YjQ2FA9lbZhaLp",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "h$?m^S)y8^Y,VP]gSNK9",
      "name": "Map/Wave/Step"
    },
    {
      "id": "Gd3A$0XfD8mLI%JeB+OO",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "%lzGgkjJPSndrAJY9Zp0",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "3pzRy0dW7znlUSjoD}_3",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "7m1HQm@Pkj=`I`$F.VUL",
      "name": "Map/Wave/State"
    },
    {
      "id": "~Tyk)XX;a(iqUW*A2FbA",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "+$f#jJ8lp^MVvH:*Bn2@",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "!iikJQLHXigu1w+]8K;9",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "8s3Y2n@)WQ?})xVLV2}d",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "qM`8nE?enu?Yc`tJSg_3",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "f*8K-Bj`$C@XR|!xmIx1",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "2ZCjXW}.vG_k}a!]/Yuq",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "N9@v;ipe`G:W6YEd_:uJ",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "|C}H9aE|qUT(tX%Iicz$",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "BW(W4VNGoO{s/VsZwOYZ",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "X_,Go@baA]CG3Duy*9wd",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "dB4sVdjyM;=.k{9khh:]",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "Cu!e5X0mwBo4Y+dKKz0-",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "fv$AO,Mx7i}i@Z7`TJTu",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "CPF=Z{4;y3-#.$y@2H;m",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "Zyb/+%$/]lBma?_?XKot",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "l?^YYocJ`]$h64#G~.4b",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "3{hcP/!]|YH1H5jqHoX{",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "t^7l!P_^}jrfl:]n)qMC",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "q:n@$sS2djIR~3g8fp9W",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "bGqQ,IqHI|-0B@Xe-|oF",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "P!Dtl;Dy?5s4JiS8o4c)",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "1big[)PO`mgH#6Hg{)kA",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "o)x`=S?FV};pSKT+iF-0",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "EQTWNIS2*iGtA7^foESL",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "%=Nf#9QPK;N*%=E,*Ig1",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "-2~X`G5#K+/?R]Q(,9Y*",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "OHun3K0dxcei#_wtKDtN",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "mWM9nD$JE?XjmDwGP]*f",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "G=7uSG*Y^zn*2pc]iUsi",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "8q;aVw-Y`ziYhD=~3MV3",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": ".R,{S4gg2[u)P;]:5y+B",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": ")?8pLd.#urEGlt65QZEV",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "9W/t1AzXw/wj`LCzc`0X",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "L*w3+M4KLgNz)Aw#y`36",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "Q%Gm)b}q9dg_[0wRTx[$",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": ":;D)fP2?%?|SJ(Dub*|t",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "cf4?~m2ir/!KM7s{vxPr",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "+rrG0fUeyT~9wC[23H-_",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "t@b{a@t0[n(HB#6kk7+2",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "H[L+{y`/{O3tbvViEXPK",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "@S-ZeDk$98QRf+b:}{~:",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "T32=%Idd=:u1t]lRUACR",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "A~}hC,t8y4xK.nf0st@H",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "WeG]v`$Yn8;1jz}G!5F2",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "lt9~];xz:}lOf^TNUKK#",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "JZFk`R0x;31EAHB-kdw|",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "Qg%U?|C[wm{H(km*JXZn",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "@)Z@/5iUp28i|;.@!1jT",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "u2)!A,$v6+4?p1Yv?D{u",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "J3IZP$eRyeT=[o,enL6x",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "EfrEWm81V[Y$0oZ{le-1",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "ZpWb.#g}jNoG8[3[xYbl",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "Qv1x/nXaOg0s(osv5OA?",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": ":`00[t4?J3d)v``KDsHv",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "0=hn{@I~Uc^nGv!)uHi=",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "~#,V~nr;HY$p`@@N9+a=",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "Og216GKzcg43jSvrx3Wq",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "80B7O)]pcXhNg^LbFwbP",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "X3{ceN_IwN.py;$G2t5U",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "Iu}se?K99B)5~67/HVEO",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "Awzr.LAc?}MiZ@T:5L9X",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "@MZI(xfJHyC+~)B=,t7E",
      "name": "@Map/Player/InitUseSkill3"
    }
  ]
}