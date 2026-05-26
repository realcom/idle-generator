{
  "blocks": {
    "blocks": [
      {
        "fields": {
          "TYPE": "board",
          "VAR": {
            "id": "@r9^}R-C^r%;TbcUsUdv"
          }
        },
        "id": "Yh$1Hs%`5EgJ7XO3EV21",
        "inputs": {
          "VALUE": {
            "block": {
              "fields": {
                "THIS": true,
                "VAR": "unitVariable:PositionX"
              },
              "id": "#!9AM2`GekXhNhN|:5ND",
              "type": "variables_get_reserved"
            }
          }
        },
        "type": "variables_set",
        "x": -415,
        "y": 385
      },
      {
        "extraState": {
          "hasElse": true
        },
        "id": "B/LM.)LHzUnjQ?z/xofB",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:SetMoveDirection",
                "THIS": true
              },
              "id": "P=qJ|7O}|Dfmtwq~~mXI",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 0
                    },
                    "id": "?CS!#Rb5GA!zIz:rCp6c",
                    "type": "math_number"
                  }
                }
              },
              "type": "function_call"
            }
          },
          "ELSE": {
            "block": {
              "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:Stop",
                "THIS": true
              },
              "id": "wA!Y]KP}X1K6^}ag]MC`",
              "type": "function_call"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "AND"
              },
              "id": ")T`$21X!q}){QU__;~|I",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "OI=*tB[[Q4uK?g`$+Oor",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                          "fields": {
                            "NAME": "boardMethod:GetBoardState",
                            "THIS": false
                          },
                          "id": "jNx1FA,BU?;,hzhU[,oK",
                          "type": "function_call_return"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "VAR": "2001"
                          },
                          "id": "6(#GF}5WzO@]4.Z}W+i6",
                          "type": "gameboardstates_get"
                        }
                      }
                    },
                    "type": "logic_compare"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "OP": "AND"
                    },
                    "id": "VZNVUm2VI)+:!YVavpig",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "OP": "EQ"
                          },
                          "id": "ft.7rch:o(ie@^bJi6rh",
                          "inputs": {
                            "A": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "board",
                                  "VAR": {
                                    "id": "k%nW,x~fo2;-2kbb_J%H"
                                  }
                                },
                                "id": "o#jAGfWRq@Z1Q{kCK06r",
                                "type": "variables_get"
                              }
                            },
                            "B": {
                              "block": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "Sw`@(gqCXSulCn[03a8}",
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
                          "id": "fjWR:C1@gClIg=jfnVVe",
                          "inputs": {
                            "A": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "board",
                                  "VAR": {
                                    "id": "Uc5*OMZ!ZSu,a*{m$2h^"
                                  }
                                },
                                "id": ".Q0CWkW5is@02/_l+=TP",
                                "type": "variables_get"
                              }
                            },
                            "B": {
                              "block": {
                                "fields": {
                                  "NUM": 0
                                },
                                "id": "P/5I1S::q*WTZOh`GMkA",
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
              "type": "logic_operation"
            }
          }
        },
        "type": "controls_if",
        "x": -425,
        "y": 515
      },
      {
        "id": "$jjQV:`lD1|,_dZu(N?^",
        "inputs": {
          "DO0": {
            "block": {
              "id": "Hpd6=usSW-!8a:~x#{%F",
              "inputs": {
                "DO0": {
                  "block": {
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "*~HzbYH2fsF-/GF~w`zV"
                      }
                    },
                    "id": "{%b26$W5M3_[C!epb8{$",
                    "inputs": {
                      "VALUE": {
                        "block": {
                          "fields": {
                            "OP": "ADD"
                          },
                          "id": "SC@.Vii,cf1!U{byCOd%",
                          "inputs": {
                            "A": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "caller",
                                  "VAR": {
                                    "id": "*~HzbYH2fsF-/GF~w`zV"
                                  }
                                },
                                "id": "Cxay.[/)7i0_faV*SE`G",
                                "type": "variables_get"
                              },
                              "shadow": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "j0G.Q3.*,vlU^:=p)g^h",
                                "type": "math_number"
                              }
                            },
                            "B": {
                              "shadow": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "j,VtXu*0QZ)nsj{A)YBm",
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
                        "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;현재 레벨 입력&quot;,&quot;name&quot;:&quot;Level&quot;}]\"></mutation>",
                        "fields": {
                          "NAME": "boardMethod:StartLevelUpSelectTrait",
                          "THIS": true
                        },
                        "id": "c{(Kx9!{k.p5mEGJr?/J",
                        "inputs": {
                          "ARG0": {
                            "block": {
                              "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                              "fields": {
                                "NAME": "unitMethod:GetLevel",
                                "THIS": true
                              },
                              "id": "Ep!!!eh8,|Y=$GB~A5L.",
                              "type": "function_call_return"
                            }
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
                      "OP": "GTE"
                    },
                    "id": "bAG/L9f,ulx#qHjZ*t%w",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                          "fields": {
                            "NAME": "unitMethod:GetLevel",
                            "THIS": true
                          },
                          "id": "K1G(yv%JE7=A(o+n1)ea",
                          "type": "function_call_return"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "OP": "ADD"
                          },
                          "id": "_ng?l?Wo5p2nS?TcR_fy",
                          "inputs": {
                            "A": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "caller",
                                  "VAR": {
                                    "id": "*~HzbYH2fsF-/GF~w`zV"
                                  }
                                },
                                "id": "+%Piq|UVN%7TI?h%Rk^X",
                                "type": "variables_get"
                              },
                              "shadow": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "#JxZV}I!wd^hk;H#dp~Y",
                                "type": "math_number"
                              }
                            },
                            "B": {
                              "shadow": {
                                "fields": {
                                  "NUM": 2
                                },
                                "id": "M!t#2:}WF^FhOv0XE.ir",
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
              "type": "controls_if"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "LT"
              },
              "id": ");QiT|Kh@}N0j`p$]BO*",
              "inputs": {
                "A": {
                  "block": {
                    "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                    "fields": {
                      "NAME": "boardMethod:GetBoardState",
                      "THIS": false
                    },
                    "id": "0N7`w_jvT?Eofa_5-W}C",
                    "type": "function_call_return"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "VAR": "1000001"
                    },
                    "id": "#ZR5djJIFv9I?(fp7;Iu",
                    "type": "gameboardstates_get"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": -405,
        "y": -185
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "UNIT_ONUPDATE_MYPLAYER",
    "period": "015",
    "triggerType": "1"
  },
  "scroll": {},
  "variables": [
    {
      "id": "Pk_C9$bMYKP9^;E3?SOd",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "t8}{(k,PL+*HVhugBPYz",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "8gmY2jw1Rt.4h,bA.l*b",
      "name": "Unit/Time01"
    },
    {
      "id": "YUZIUc.PNTq$pq^x[6$4",
      "name": "Unit/Time02"
    },
    {
      "id": "0*A_WOr8J7QW,y/hzfCu",
      "name": "Assign ninjas to the farm to gather resources."
    },
    {
      "id": "w..HHCna;p}##6l2]g}:",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "%X^OY_2|5%nE@P79F@-e",
      "name": "Assign ninjas to the mill to gather resources."
    },
    {
      "id": ",fRqKb]3wlZ/6,ITt?ik",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "-cn@KCYqG_[o(FtJ[9FJ",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "`|TKvPGQ7_gwQf2z]RUh",
      "name": "Points used to calculate battle rankings."
    },
    {
      "id": "pCGN4)Ajm*-H-zm^-Mj{",
      "name": "Points used to calculate friend rankings."
    },
    {
      "id": "|Uz9Z/H4=;E3R7#,JdO;",
      "name": "Unit/Tick"
    },
    {
      "id": "{s3THd~6Zs,2xG/6Va+`",
      "name": "Unit/Rome"
    },
    {
      "id": "JS2C2`a6(#XiH^Exs:mT",
      "name": "@Unit/Delay"
    },
    {
      "id": "`]yA#iNhQn_c-J!`n=L7",
      "name": "@Unit/Range01"
    },
    {
      "id": "-a]=h#|Q?)WK(;^}S)*d",
      "name": "@Unit/Range02"
    },
    {
      "id": "c?T`bybI5vnCB`h_2b0D",
      "name": "@Unit/Range03"
    },
    {
      "id": "d5FzDgtUio/N3`[Nz9k3",
      "name": "@Unit/Range04"
    },
    {
      "id": "BXH+78/UL0Tn1WbU=.q|",
      "name": "@Unit/Range05"
    },
    {
      "id": "]H-%a4UCc?z}%#teZj(?",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "iWGD_T9gPCEu~Y;#Wpoz",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "L=,%B869A%dBEOmwp%@G",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "8gLzjB|R)]nzNHcwXfri",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "5:Z%[Ff77Ss/t|oE$t-.",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "G}=}^hk0BN#9kN|D]F:I",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "nKS^EGGncGMRXxR1r*Ax",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "|fiIJ;`R=|n|z#L,baHX",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "sPNIW)~AuLO|PI|q!i}p",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "VJ*Ec0WA6e0gJ`b;4T4@",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "DWEo`y2(QZ?iaNXewkXT",
      "name": "@Map/MonsterID01"
    },
    {
      "id": "w!?_)*jWLVtu@gj]$,H2",
      "name": "@Map/MonsterID02"
    },
    {
      "id": "keyc^}1`sOiU|_:.2Ei]",
      "name": "@Map/MonsterID03"
    },
    {
      "id": "}}(OUwJ:AgKm:l,pB.zp",
      "name": "@Map/MonsterID04"
    },
    {
      "id": "Hg$g;cS7k~[(Q/l/j9y*",
      "name": "@Map/MonsterID05"
    },
    {
      "id": "LSe(EHcnQ/4.0[,{jjZt",
      "name": "Obtain a random Normal grade Head"
    },
    {
      "id": "`:!DAzDGdbz;9sr7j+c.",
      "name": "Obtain a random Advanced grade Head"
    },
    {
      "id": "K3K?P6X!}JP-!pYIKX-k",
      "name": "Obtain a random Rare grade Head"
    },
    {
      "id": "q/kbELlsQxQA|45K$nE+",
      "name": "Obtain a random Hero grade Head"
    },
    {
      "id": "zF{qi:={C{9Q=Ury0q`^",
      "name": "Obtain a random Legendary grade Head"
    },
    {
      "id": ";zt@=iHn7;2{*iy?LtQG",
      "name": "Obtain a random Normal grade Chest"
    },
    {
      "id": "x2|MK_IlRd~_g)|go4=R",
      "name": "Obtain a random Advanced grade Chest"
    },
    {
      "id": "ls@v6y%MA=c$p9JjH}El",
      "name": "Obtain a random Rare grade Chest"
    },
    {
      "id": "2N4tIn7]8J!ZEHm]+69g",
      "name": "Obtain a random Hero grade Chest"
    },
    {
      "id": "`Sh1W1v|1IJSh=,]3/pz",
      "name": "Obtain a random Legendary grade Chest"
    },
    {
      "id": "eNw8uh?4+!ieNkm+2_!j",
      "name": "Obtain a random Normal grade Gloves"
    },
    {
      "id": "B^C0^.yc0ew,cqV,?+_B",
      "name": "Obtain a random Advanced grade Gloves"
    },
    {
      "id": "/Gq$/E^jHNf/LlGMnV@l",
      "name": "Obtain a random Rare grade Gloves"
    },
    {
      "id": "Y=M5G1:!w)n~*kjk3e[#",
      "name": "Obtain a random Hero grade Glove"
    },
    {
      "id": "AW++)J4OisDWP}u5CsQH",
      "name": "Obtain a random Legendary grade Gloves"
    },
    {
      "id": "ft1]1;Gb0DketcS=~{XB",
      "name": "Obtain a random Normal grade Boots"
    },
    {
      "id": "EL1ZnE}w!ju{aoi(%gp]",
      "name": "Obtain a random Advanced grade Boots"
    },
    {
      "id": "_]v[x4!]#k;7oX]%//u.",
      "name": "Obtain a random Rare grade Boots"
    },
    {
      "id": "Jetr]`5gwj1]eT^31E{y",
      "name": "Obtain a random Hero grade Boots"
    },
    {
      "id": "v*I/Kb,|}k]K,L`eBA|~",
      "name": "Obtain a random Legendary grade Boots"
    },
    {
      "id": "@M`i/kls;7-y*[KiKdB*",
      "name": "Obtain a random Normal grade Necklace"
    },
    {
      "id": ".x:jEVEd`UN#1I/[@u^d",
      "name": "Obtain a random Advanced grade Necklace"
    },
    {
      "id": "79AEYdn;`oSc1Op4[@C{",
      "name": "Obtain a random Rare grade Necklace"
    },
    {
      "id": "Wrku:MSUfH5Iy?uxJ7Ek",
      "name": "Obtain a random Hero grade Necklace"
    },
    {
      "id": ".qizGN:+f@^{|rE6a(Fv",
      "name": "Obtain a random Legendary grade Necklace"
    },
    {
      "id": "}#lA!QkmVCQT)qq@rWF{",
      "name": "Obtain a random Normal grade Ring"
    },
    {
      "id": "7)p@InNS8zHuT3ay[#LS",
      "name": "Obtain a random Advanced grade Ring"
    },
    {
      "id": "Vbn{J}aZwNW@5xkVr!l[",
      "name": "Obtain a random Rare grade Ring"
    },
    {
      "id": "Stx0D6e0%K?:V[-EV~HX",
      "name": "Obtain a random Hero grade Ring"
    },
    {
      "id": "D?2**u}:M=_xBUn.CBGa",
      "name": "Obtain a random Legendary grade Ring"
    },
    {
      "id": "~d#^g#XZ5/]yI:2k{/6x",
      "name": "Unit/DefaultSkillID02"
    },
    {
      "id": "^-O3#AiY{T(WKME8=HD%",
      "name": "Unit/DefaultSkillID01"
    },
    {
      "id": "btXSgO_,RE~(jLh^mR4J",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "@r9^}R-C^r%;TbcUsUdv",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "mF(b|=-Owz{B83::}.fK",
      "name": "@Map/MonsterID06"
    },
    {
      "id": "hwW1BSn=B5*SxCkxV(Pv",
      "name": "@Map/MonsterID07"
    },
    {
      "id": "^K.Rks7jnu/Ls1wh5e7U",
      "name": "Map/BattleValue"
    },
    {
      "id": "e!y41b(?gUj3nejZAD3g",
      "name": "Map/IsClear"
    },
    {
      "id": "A8s=jyX+7BrYSFjC%$|1",
      "name": "Map/WaveCount"
    },
    {
      "id": "PIqq!.mC0Y`LdH;h,g3k",
      "name": "@Map/MonsterID08"
    },
    {
      "id": ")[[;~%4v_%?}L*:H8LaF",
      "name": "@Map/MonsterID09"
    },
    {
      "id": "%RnK4ECCKP*$eoPm/^XF",
      "name": "@Map/MonsterID10"
    },
    {
      "id": "(p[#.1?r21bm$ay:aWmG",
      "name": "@Map/MonsterID11"
    },
    {
      "id": "BlrPFK:/]u3@6q8{6M`4",
      "name": "@Map/MonsterID12"
    },
    {
      "id": "sp?JoY7j4-ugli*ipy*L",
      "name": "@Map/MonsterID13"
    },
    {
      "id": "r.?S!S]uIgVAnA_(HKck",
      "name": "@Map/MonsterID14"
    },
    {
      "id": "t67Uv[G$JXudbI+t~*k6",
      "name": "@Map/MonsterID15"
    },
    {
      "id": "DC$%`L!%r[*{d[GRcS{k",
      "name": "@Map/MonsterID16"
    },
    {
      "id": "~[LVQb,a6*8DAgq|^4aK",
      "name": "@Map/MonsterID17"
    },
    {
      "id": ";]%dABC=b[O~;~35fL)c",
      "name": "@Map/MonsterID18"
    },
    {
      "id": ";4D;d2@f;v`T9Q8rpWn/",
      "name": "@Map/MonsterID19"
    },
    {
      "id": "yi,et%k[Dv)s(8w?rsp(",
      "name": "@Map/MonsterID20"
    },
    {
      "id": "G:vg9|;M^*f7i:WjP;R6",
      "name": "Map/WaveTick"
    },
    {
      "id": "z!re{i;|J3A?z6D]6K]g",
      "name": "Map/IsSpawn"
    },
    {
      "id": "pBwU%-}}VM*(wP*u`{Xb",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "Fm5Zy/HNs|q5-W}Vlyzn",
      "name": "@Map/AddBuffID01"
    },
    {
      "id": "DPmFN`z|N1Sb*BmuD}eP",
      "name": "@Map/AddBuffID02"
    },
    {
      "id": "`V-0}{-N,D{VRY,tJ%QG",
      "name": "@Map/AddBuffID03"
    },
    {
      "id": "j=Ng`#y=F,,!e%!:*0Ox",
      "name": "@Map/AddBuffID04"
    },
    {
      "id": "=v*d`-/Mk2MX?D|hZCi#",
      "name": "@Map/AddBuffID05"
    },
    {
      "id": "o6TUQ`$V!%,5f][|ye$:",
      "name": "@Map/AddBuffID06"
    },
    {
      "id": "P?E66)G43[0{#,QUi0zK",
      "name": "@Map/AddBuffID07"
    },
    {
      "id": "S^HPOk0r)+#05]Qzmw_r",
      "name": "@Map/AddBuffID08"
    },
    {
      "id": "[aUSJ39]2[eP#5-}4N,@",
      "name": "@Map/AddBuffID09"
    },
    {
      "id": "/[_9|7^8*.=rY+rP_MfY",
      "name": "@Map/AddBuffID10"
    },
    {
      "id": "-vuW0D;Tm|,xFt;%-o00",
      "name": "@Map/AddBuffID11"
    },
    {
      "id": "xc,pCz;bTz]GMV(z4?o{",
      "name": "@Map/AddBuffID12"
    },
    {
      "id": "Lh/Z4.~G#S+|jt$OMcFs",
      "name": "@Map/AddBuffID13"
    },
    {
      "id": "NtmZzLgpHrHRPr(KK~/|",
      "name": "@Map/AddBuffID14"
    },
    {
      "id": "V!eN,Hdn3M^c6cLql2C0",
      "name": "@Map/AddBuffID15"
    },
    {
      "id": "rBXU#-AK7UN#VIxygM09",
      "name": "@Map/AddBuffID16"
    },
    {
      "id": "N3)A4(PDG,;ag`Mvr=o1",
      "name": "@Map/AddBuffID17"
    },
    {
      "id": "J~.|jOTQ;#`p[70(gw$*",
      "name": "@Map/AddBuffID18"
    },
    {
      "id": "?tiM(,3frZ8vWq:@~uKC",
      "name": "@Map/AddBuffID19"
    },
    {
      "id": "C83yQ[EC5fG|`GpTu6D,",
      "name": "@Map/AddBuffID20"
    },
    {
      "id": "[D-YoplVY$1b=):s6HI~",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": "y5oapOmpZ2g4:e1^Y~_Q",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "q(,32cXG4o(AtEY?QR;B",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "vU)7y9p?hck98;lxIsPv",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "T`DCoW?T/lu3Ejg|y|PO",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "he+6VjH,z+!X_7@U61X8",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "crK*-A%b*BeaLuKeLETq",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "yzDWI%Fu$G}jSOpQ{T-e",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "HVc5/U1kFR[;LtQ0-W]4",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "nf466;11qHb12ereXBX5",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "A4^t)A|7sTbNplldp4c%",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "8l,N@HVO!UPC@Cyv:o$?",
      "name": "@Map/MonsterID21"
    },
    {
      "id": "Vc*dIg+7bYKX,KEWpR?b",
      "name": "@Map/MonsterID22"
    },
    {
      "id": "hDt9s.6g?6TJ,:58|L+g",
      "name": "@Map/MonsterID23"
    },
    {
      "id": "%gFtTPT){rh+o]ZVh,^O",
      "name": "@Map/MonsterID24"
    },
    {
      "id": "dgu~KISu:sJcKuz-C{^n",
      "name": "@Map/MonsterID25"
    },
    {
      "id": "dkFsm^:Oko=M5^KCtJ#0",
      "name": "@Map/MonsterID26"
    },
    {
      "id": "{mn|eft#+W56fvcK3*hq",
      "name": "@Map/MonsterID27"
    },
    {
      "id": "sYl-G:*GG9bM}@kt^{Dj",
      "name": "@Map/MonsterID28"
    },
    {
      "id": "na?rl~Y7K0Hu5[tH.IVO",
      "name": "@Map/MonsterID29"
    },
    {
      "id": "d+L8Fan[Vr4m-Si!mtG]",
      "name": "@Map/MonsterID30"
    },
    {
      "id": "b:G~@IT1EOFo%ArcMQm1",
      "name": "@Map/MonsterID31"
    },
    {
      "id": "*vt|k|^z1ub#hS,h:h4=",
      "name": "@Map/MonsterID32"
    },
    {
      "id": "/D@mr;#bJtamPZ2y)N%N",
      "name": "@Map/MonsterID33"
    },
    {
      "id": "yM+nz[ExV_-__KW,~c8-",
      "name": "@Map/MonsterID34"
    },
    {
      "id": "R`!tueXT:rRl?]O4@:94",
      "name": "@Map/MonsterID35"
    },
    {
      "id": "2EUe2[d;w|(YMgU=4J3C",
      "name": "@Map/MonsterID36"
    },
    {
      "id": "2=/(L=:.}IFs4GTeDK}M",
      "name": "@Map/MonsterID37"
    },
    {
      "id": "8P(Zeu]9$Y#{$7^P0bkj",
      "name": "@Map/MonsterID38"
    },
    {
      "id": "Nt+B^KlKWFO9Ci)KF4nz",
      "name": "@Map/MonsterID39"
    },
    {
      "id": "!wrZQGPR$`FbGgT6n.q{",
      "name": "@Map/MonsterID40"
    },
    {
      "id": "OPBzlLw%2s:BxIjDCiT6",
      "name": "@Map/MonsterID41"
    },
    {
      "id": "G0xJy!!AAI6dzF^6LdCQ",
      "name": "@Map/MonsterID42"
    },
    {
      "id": "8m9Lhk)OdzYCIq+/.NhV",
      "name": "@Map/MonsterID43"
    },
    {
      "id": "GA@O%;a7dGhm=)R8ksBv",
      "name": "@Map/MonsterID44"
    },
    {
      "id": "N7kKBfr$fJwM_B](s7bG",
      "name": "@Map/MonsterID45"
    },
    {
      "id": "C@kGkh^(vxxmuURj-C]E",
      "name": "@Map/MonsterID46"
    },
    {
      "id": "vmD1NABtO3sofh_R~]cC",
      "name": "@Map/MonsterID47"
    },
    {
      "id": ",%5j6FdDBAMMMDddUNXg",
      "name": "@Map/MonsterID48"
    },
    {
      "id": "Cdte$S92]]Mcdg*kjon`",
      "name": "@Map/MonsterID49"
    },
    {
      "id": "D`u#bmBCdayFdz(^.0@p",
      "name": "@Map/MonsterID50"
    },
    {
      "id": "B6pbkT5Dz_o.QzX$m-tu",
      "name": "@Map/MonsterID51"
    },
    {
      "id": ",nQ71.%%z.e|Zew4;hH?",
      "name": "@Map/MonsterID52"
    },
    {
      "id": "m8:;K26N;xc648;Wzbza",
      "name": "@Map/MonsterID53"
    },
    {
      "id": "nenHJfh$fL,o20]|MnHY",
      "name": "@Map/MonsterID54"
    },
    {
      "id": "OoONB}Ky|?`VyY)f5P-Y",
      "name": "@Map/MonsterID55"
    },
    {
      "id": "(W%Obh~4{]{Y}[z^i4p]",
      "name": "@Map/MonsterID56"
    },
    {
      "id": "/FzYmB~a8$m//(XuyknX",
      "name": "@Map/MonsterID57"
    },
    {
      "id": ",oT[uQjov[^D!T1f_O`Y",
      "name": "@Map/MonsterID58"
    },
    {
      "id": "4Yk0CO1vYfwknux69QPT",
      "name": "@Map/MonsterID59"
    },
    {
      "id": "2fGv:y)%l7!_E6YA[H%`",
      "name": "@Map/MonsterID60"
    },
    {
      "id": "EH^^A`*hzg{Gf1t6~OpT",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "*?{NkK9Jz*+q#K9yfq~l",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "Z.:CnxMsnW/5X|Hm1EzE",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "+0yKt/n?`%wqgIcygVr)",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "]`V,9z;s:lTwl)`rPX`u",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "mQGMt=aa#D]:e)`k~[-]",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "W+9lFrs`w0avWNp]OsBt",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "QmAX_^?[*CGu`30u@H+J",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "YqP1c_Lu3FhmR)l,6igp",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "QF~5%XvXqAZPUT?p?;H?",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "{,zdhhcpMU[A}@G1vM$(",
      "name": "@Map/MonsterID61"
    },
    {
      "id": "y,~UIfe=G-s7C74pM4W%",
      "name": "@Map/MonsterID62"
    },
    {
      "id": "-Qo3YXinl@.0nYi36wxt",
      "name": "@Map/MonsterID63"
    },
    {
      "id": "`qaKu#tvEGk}~r;YC9#a",
      "name": "@Map/MonsterID64"
    },
    {
      "id": "gRlI[QLpjF!+n.B![Sr?",
      "name": "@Map/MonsterID65"
    },
    {
      "id": "]}3@oo(QJPuD!XdMi%.}",
      "name": "@Map/MonsterID66"
    },
    {
      "id": "+xpfa1BDRH79Ch0/km6S",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "=.0YN|w_^3w[x60t!H[7",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "#]:x*i%0^cb4/q[nuj7/",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "J0zEd;.Zp!S6_`:DRB;O",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "0=UZcm2%rle_MDNI/u.x",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "{XmzG1%2@Zyqpilr;f~S",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "[S8NO88ZbC@1^=JCkeW$",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": ",j[9v*ra+1F:Lf!bq{3j",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "o5/?cne?2]jt+tXpa1mU",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "JD8EwuOw#]aMY[~98t,3",
      "name": "@Map/Variable01"
    },
    {
      "id": "[CeXdaBGHj7DYwOMqg{;",
      "name": "@Map/Variable02"
    },
    {
      "id": "4LBb@wj2PSib*e1:yDl0",
      "name": "@Map/Variable03"
    },
    {
      "id": "+13L*9%[QOmGuF*jxDBz",
      "name": "@Map/Variable04"
    },
    {
      "id": "d1HKPHI15_|=.;W^R3_Y",
      "name": "@Map/Variable05"
    },
    {
      "id": "2$iDz{c-nO7gJb.E7;T_",
      "name": "@Map/Encounter/Unit1ID"
    },
    {
      "id": "?qNU.qeO8T]CCbM4`UVo",
      "name": "@Map/Encounter/Unit2ID"
    },
    {
      "id": "q^1;0IuVJ%h}.i}P]q4)",
      "name": "@Map/Encounter/Unit3ID"
    },
    {
      "id": "%ypE4Fx|b8hBs/!|a+Jr",
      "name": "@Map/Encounter/Unit4ID"
    },
    {
      "id": "g^1H}rdj?c3@C|%#Ri}|",
      "name": "@Map/Encounter/Unit5ID"
    },
    {
      "id": "JcbG[I#!C#:q!xH/`F+h",
      "name": "@Map/Encounter/Unit1Percent"
    },
    {
      "id": "rVJ^c$!U.LXWRouc7sx[",
      "name": "@Map/Encounter/Unit2Percent"
    },
    {
      "id": "pDHA,r_o!Fr}r22NqjW0",
      "name": "@Map/Encounter/Unit3Percent"
    },
    {
      "id": "p{J942Zkm.gpVZb-Lkmf",
      "name": "@Map/Encounter/Unit4Percent"
    },
    {
      "id": "O1Y+CEqxH}%WCyJmS.$p",
      "name": "@Map/Encounter/Unit5Percent"
    },
    {
      "id": "TI%(fOu=O{8AP6jLF:2k",
      "name": "Map/WaveStartTick"
    },
    {
      "id": "uF^vG7|j:73H*(jfV5Wz",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "pMH4aAe]VfDmDRQ`R06%",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "7e$LIEywGoSHm-;62zyG",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "R;uJ+(F#O.tLFM6CJY1-",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "=Hgx=)n[qUUBEIk~|_n`",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": ")d,*N#EXPTt#uYdj1OF8",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "k8#(mIK#i(D2;hD{-95x",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "mEWC0KW3y5,Ux@#%(edO",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "zzkjq+:E7VW5~1mDFyH`",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "tSS,~aZSeebA(Fy1gYX|",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "ARtX$tjW/g61!GhETiO6",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "w/~/^OpY+p(Q[`RjYEo@",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "fmti~*L@77MapDeG:APC",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "nZOJ797*Z6:qYU.jU,~:",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "*4%{.rNjAaE{WKsk6g-Y",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "+N1A%zZ1FQ);m1/k)0OB",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "uNd(Fe*YM:z{P4gOv6Zg",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": ",9o8q9o@1n[_`e|tp^Sg",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "d;(u[i~LRG-!6l3=ML)c",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "?)TMv3`nKICoD@$3Tpi7",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": ")PjEGiaA]0,^m%rgKr.K",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "$+8iq3m,hn^*VDT#5W[G",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "?-}XzQztE;i+CkE@@DOe",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "lwUwO6zfVf:5s;Ej|kY,",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "UXw4H:|KPv{{8a^UQU%:",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "4u*%:0[Z$VGus,H?bT$O",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "^m#F3Sgx6d/o{q|(4I=[",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "$p3iaDQw*_%0#Wq8?$lb",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "LS|as01f`p9WS]upy@f6",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": ";=MMq`or:Z*4o*WEMJ0F",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "iALV*/61-q`?nETWTws/",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": ":jUg1@s_rMXTMr9JyL=P",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "qBj#hr=Y|ONJiKiR$;`o",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "-ATgz9I`GZmx%ryG,CLV",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "%)rRP%sW+8e^5zoX9_[Z",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "w=vHFji`wc;N1qxhtO^u",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "(9.KjW^D_~!Vf:_IQW;!",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "fF-fgu9|]5K(%;;/DYFN",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "Zh@`c1tL6o3!#uU%$Zxt",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": ";mZw0jf_:?T98CP[EIiC",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "-eB}I8NJ?.NkrFiAu8w^",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "Z_rx)z^V^c(}#NrNs.3.",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "25B4~_NT|5ln,r[A4jAJ",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "~cl4[KaP.Oun(fnEs){G",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": ",bb1,|oFn:4x=CK=YV6_",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "QsU(rRI2J:)nkktWxPHD",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "t8F#@H;]oF8A|a6[r3U2",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": "rOoz7gV!K^Sz:AH9LH~`",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "QIs-ul5W;y0L$69_M_bc",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "UD[-0Sf,N3)x(=[+{$bQ",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "lywoESv9-(!fF6p3Bd$B",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "YlwtRF)SGC;?$X]+/w/T",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "{!`zJxgE`vjVZ3je!V{S",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "J4YgQAiEy=sw;Z_dg;#Y",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "G2v)r%KBZ$oW*lbw|!!W",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "977lunZlL-O5XI.iKYL~",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "{w}CIY{vjsEjQ)}zd?ud",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "R|[KS%4-5[[C@/JmRZ@U",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "7Rq40Z03|=]N`,:H0i4{",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": "Y9{I~{j7W.(.jv1/?)Wj",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "v212E`IY6hPF?gW6!jR@",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "_lDF9WQRnEyvc?@q*E^*",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "+dqt4pCx6?o5*13q|lNc",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": "_h?bJ;)brf+e._l~dS?i",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "[o48T3!|ZgTgf^);rl2v",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "v|2NjbefNanc[CJQ~qz]",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "E{!QM8/{-wQ-+0:oraS5",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "4A*M,*lm;n2pWsPo9P.;",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "qWX7u%tBR5DYr5:!q+V+",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "SMsJv)?GUfL@Ezd{#0V(",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "E=KLt(DREC6}!Qm^Bbb,",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "ZDR@;3y-|p{zm.Y%yI=i",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "ma{d`T`-2OH3{4[#`SFt",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "dYCk{@cnv#rj9aJCD?OD",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "aog~8tW/P;V}IVtJ+EF.",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "uWZcEm*p#d-Aj0WU([G]",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "Psh?sJ7QM$bRB//!?!Vt",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "NBhCp@@MV5z^VMU%*?;r",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "3;!n9{nq[AoSB$BR]2Y~",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "0G8uh4-W1j=,M0AX[g[)",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "V(B;*rG/AHWzhL-TU`Rz",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "+:Lz^x5iQ=gk|J3J]0,s",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "yOi`a+O#RUcCLt`8hBf?",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "`p5|IGu0#SHNr_,N%_kE",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "=Rwrb9XqGV|PIx`LM`:P",
      "name": "@Unit/Variable01"
    },
    {
      "id": "v19Mk$oCTIv!ff]d4-Sx",
      "name": "@Unit/Variable02"
    },
    {
      "id": "m4z3lIhp;kAavr[e9OTH",
      "name": "@Unit/Variable03"
    },
    {
      "id": "XmE_UCTkEA6!P+HQ=Zt4",
      "name": "@Unit/Variable04"
    },
    {
      "id": "DO@fh)4Hf4ocN-sCC2kX",
      "name": "@Unit/Variable05"
    },
    {
      "id": "Uc5*OMZ!ZSu,a*{m$2h^",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "RUhI?P#L!eD$8MPs|/XI",
      "name": "@Map/Encounter/Variable1"
    },
    {
      "id": "-s{f8|z7S_bSC=Yc^s*b",
      "name": "@Map/Encounter/Variable2"
    },
    {
      "id": "8*RdK`(S{;0upErs21V/",
      "name": "@Map/Encounter/Variable3"
    },
    {
      "id": "8fKzphYkL^M0-TbIn=Gm",
      "name": "@Map/Encounter/Variable4"
    },
    {
      "id": "1jisq9AeRn{jAUn!ho.]",
      "name": "@Map/Encounter/Variable5"
    },
    {
      "id": "$00s[);7D)CpnU8fVo.X",
      "name": "@Skill/Trait/BlastIncreaseKBPercent"
    },
    {
      "id": "*~HzbYH2fsF-/GF~w`zV",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "iWjMZqaaDy1EJurkIMQ;",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "|HKBK)t.uZ/c#M8Zw5c?",
      "name": "보석 상점"
    },
    {
      "id": "VSFnc%5fWQnml9g[2;9d",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": ".iqR{|C!iPsJs~;OViG-",
      "name": "Map/Wave"
    },
    {
      "id": "p=t1=)DgM9wp*9z}pRR+",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "L|5h4%8vZb@Yw0o-hv+m",
      "name": "Map/Wave/Step"
    },
    {
      "id": ":Ado/C,MUj-)cCz?Y={W",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "eF5wW.:(#M4[w6hEHtQ%",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "r}n/aZ.GKVjG%*cauLQu",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "I^Z-,T#_Y;Y$l8]gQ1[q",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "~PtVX}@=IGd}f6}Yhwxe",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "oqE]CMLU-ZWs]A(ea)bp",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "(MmZ;9p.`,hB,pClO~J[",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "^X$ks68E4o2eU5tpg#P|",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "_Xy|=_*?qDE*H3in;q3(",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "QLQW[-z[{=9C1!+9b(Sn",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "J44,m:/eB#DI-:EQSig%",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "K]7qK#usW]^Z?bO`*bRw",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "A@dVdUe-/T!v#FYX`tB;",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "d%G3-XqG`[/HLzB@5UXa",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "iO(!H2=:S0d?viV!@D;I",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "M1?`]ZF9TLj$,3F|py(;",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "4;_tb6ih!+p4241Vas(V",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": ";Vw`6Qsa5Oj2-*[KH_P]",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": ",Mqe7M/s{TFEfZ1Gs4(P",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "{ZZ/Fp3.-)g-rGZLfF)-",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "{.yTL=)NC.VolYZRpBI7",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "!pc=)a!Q$fm!vtotEV|m",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "=AO)R8AESUIyxCqbf3Ew",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "^P*)(mtRu.A$axkHgXm#",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "k@aT%g$|?hDyY~upw/_!",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "|n=TTa{`Y#hBO%KYJ3Pc",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "F7-Hlk9CaXnlKUC}:xT#",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "Yv:SXB.QTb|=8_yL=;rH",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "t_lMMmenIi0Tnqzb1,pu",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "gFTfE(70je3e[73rH$hH",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "ApR=7yBX${6tQ7Cbu@(6",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": ")8):qRGaSE!C,|Ht?1Qi",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "^^[tYhl)$S~_hoe=JzJf",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "*k58y@7!Vg)+iF_Q=?J3",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "%BAgk/@K0r@#H8fR}Z+F",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "k3}#x42F/VZ?oMhd**%A",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "ledypoM~@B,cqII=Kd)*",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "Ax{J.J|3hhboz,a:XRJ*",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "jA9#thGv0xVIhW}cdD1H",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "{3/AfVy1}_/|/x$BD_{D",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "vD_BPN4*2it?,1sCGB97",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": ",i-M~GNtQ$|4ABQ{B0pZ",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "Bo}}luQ}X#/~:pAHRE,3",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "r@s$z2^TEoNVtNdmy!mE",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "*YcXtC2oqaUv%!KX:-qO",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "dELw7PBupzkh?x?$#UcV",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": ":Ptk9$*}!3]p[U}|#c}~",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "js/i96:#9rvCogTx}*r-",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "D^:6,Ay,ko.:a/6?BKwr",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "HM).=eY9w=ba.okb_c?w",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "ae$R~?f]MlX5XUyjgy7(",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "9Lc2dl]uI$Ne$ATRN2dI",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "3LUI282gE|Ze1OaDV}|i",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "bi4-YT|`;MG0]zNg6bb|",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "bCFSwXm-BJU3,6/qe_1=",
      "name": "Gem shops"
    },
    {
      "id": "CxLXu`sW)xb?!Rp@%Y}:",
      "name": "Map/Wave/State"
    },
    {
      "id": "DEb%.btW_*)1ztT}i$oy",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "NUCo|;jb;{SH*8*56363",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "eQpe`?Y=v595{Ug/`MJI",
      "name": "Zem"
    },
    {
      "id": "O4Yk%r4u$-ZTq%5c:=xF",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "l7Olv,]w5})lDc;pQCJB",
      "name": "Gem"
    },
    {
      "id": "qk;Ve(?C`$jP~1[w;N]y",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "$2EP#S}m$wPiH+U84nn.",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "_so+k8{REjXd%!Mg_,tn",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "F;;bh}.3^x;jJZs$NeU^",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "ygL7K`(Ur4)P=mI$Vj~D",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "UL4z1WpPCH[o[I6T[S2F",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "Tcs5$ezavwT{_3.q~TtC",
      "name": "Map/IsStart"
    },
    {
      "id": "/fAvK@{Ax8^QrN+Yhl;L",
      "name": "Map/CanStart"
    },
    {
      "id": "S#VzLNeY_PKKb3Q`d2Wm",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "k%nW,x~fo2;-2kbb_J%H",
      "name": "Map/Player/Moving"
    },
    {
      "id": "Phv?hsB%T`%EDQv=zY/g",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "}HGl*]f`2WZi;]w^owL2",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "gIlb8P97TEe8UOMGq=Vl",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "Sp7u9yrSnO}Etdk,q.^C",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "mQ;]mnE},YHRv7R6Y.b_",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "Z_g`4@SH|uh}%2tH6spI",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "@|,EwTC*PWqZhk]/N;;[",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "CjIPcE=MxU5JUK#fKR=d",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "^p2USosvQU#]WW%MHUMP",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "ieex;f8y%X]BiqiNGJ?|",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "Mx$BwV.=~0(pm;f,:L=W",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "/@E-*m4!MZtn=,m*PA$`",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": ")y[2ZPw-.GOG=hw_]-bw",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "m.7L@`Ew+-od5j+Zm(x=",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "]I/5GMU[Slf/$ph0@.-3",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "YX(mz#iy7fs}E~v#3=cw",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "k_l]ywz]ek+X}O{abiQH",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "?oo$=2zt`qW[PT+-E!H=",
      "name": "@Map/Progress"
    },
    {
      "id": ";!)q0-4sm.SU!cQh$v_I",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "wm7L4z8vTzL#iC?NbBJ4",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "!|3,Qd.ds6nN^Dl0s}b=",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "sVnDbd:pQYcMZ0l=Y.P9",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "%2xfZa8s8dvlVuwY9Z5J",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "n*/-bKmS)4-uL+,]S.VM",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "`nz)ME!Yt,:7|ik(kq`q",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "LN,@fOo6NF+ug[nu@jk9",
      "name": "Map/DisplayWinningTeam"
    }
  ]
}