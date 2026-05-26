{
  "blocks": {
    "blocks": [
      {
        "id": "24g_J943n4#(8J~5*i*q",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
              "fields": {
                "NAME": "boardMethod:GetMainPlayerUnit",
                "THIS": false
              },
              "id": ",@I5lF?HjxdDr(c2OEII",
              "next": {
                "block": {
                  "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;name&quot;:&quot;PlayerId&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "boardMethod:SendResetMapScrollEvent",
                    "THIS": false
                  },
                  "id": "~I+@ynbotbGOjznu]z^!",
                  "next": {
                    "block": {
                      "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;Position X (필수)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y (필수)&quot;,&quot;name&quot;:&quot;PositionY&quot;}]\"></mutation>",
                      "fields": {
                        "NAME": "unitMethod:TeleportToPosition",
                        "THIS": false
                      },
                      "id": "tZ:{e/p3vL0~LH2W|!Xl",
                      "inputs": {
                        "ARG0": {
                          "block": {
                            "extraState": "<mutation></mutation>",
                            "fields": {
                              "TYPE": "board",
                              "VAR": {
                                "id": "uPLypx$n|n:Z#KM`qk(]"
                              }
                            },
                            "id": "mX.p?!Y=Fdg%|JpFZGz7",
                            "type": "variables_get"
                          }
                        },
                        "ARG1": {
                          "block": {
                            "fields": {
                              "NUM": 0
                            },
                            "id": "KO%2)g]4j,4-6I`.XJog",
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
          "IF0": {
            "block": {
              "fields": {
                "OP": "GTE"
              },
              "id": "w./$TD3Np.~ka/]H2@f;",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "MINUS"
                    },
                    "id": "1~B%fNEL$up$n?#T#GMt",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "k5i%D@WpP,U~pz5mf?o."
                            }
                          },
                          "id": "%arBvg(b*4h5R(Gn`N!f",
                          "type": "variables_get"
                        },
                        "shadow": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "*N4i;%v=]c]haCv{{0`R",
                          "type": "math_number"
                        }
                      },
                      "B": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "uPLypx$n|n:Z#KM`qk(]"
                            }
                          },
                          "id": "[^i%S%Vd?q(R[agY0RJG",
                          "type": "variables_get"
                        },
                        "shadow": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "^fuvvigXjwUrq0lND~w)",
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
                      "NUM": 40
                    },
                    "id": "o5fsoM`R0P015!(G:~{N",
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
        "y": -445
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Map_Lobby_Default_Update",
    "period": "15",
    "triggerType": "1"
  },
  "scroll": {},
  "variables": [
    {
      "id": "6SHOD+3C}QjMIiYJfQy|",
      "name": "Gem"
    },
    {
      "id": "5ue(_K5S?vJ}(_;e{Ui*",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "uEsN(efCY@t]Ka(W0TA)",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "EJNCgS;V2fNbPw07tdA@",
      "name": "Unit/Time01"
    },
    {
      "id": "VnZ#U.@C(q/pAq8*l_v9",
      "name": "Unit/Time02"
    },
    {
      "id": "G)k28XV1p95oX]Sv#T0+",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "0WD9[t-lXS|$L2A1D={?",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "DwmQ}d%d]T:FG9d~WdzS",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "uPLypx$n|n:Z#KM`qk(]",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "k5i%D@WpP,U~pz5mf?o.",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "FWgsc7R6Jbj3;ll|k7yI",
      "name": "Unit/Tick"
    },
    {
      "id": "^WKSjJnZ:~OXVPSm!Vlq",
      "name": "Unit/Rome"
    },
    {
      "id": "OjrOaZq,=h}wi8Gk.7j^",
      "name": "@Unit/Delay"
    },
    {
      "id": "R[Vf5gij}lUn`QtL.({y",
      "name": "@Unit/Range01"
    },
    {
      "id": "z7ws0ob;~X(3-8SgPnCP",
      "name": "@Unit/Range02"
    },
    {
      "id": "x]t/PNLtcaCODrOS?)ki",
      "name": "@Unit/Range03"
    },
    {
      "id": ";;j4L%u*N4eq{gDwN!m[",
      "name": "@Unit/Range04"
    },
    {
      "id": "r]Nc/}Di:D$-:(:G@n%|",
      "name": "@Unit/Range05"
    },
    {
      "id": "5#`zh2#!QSMrGwA#KPu2",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "R[.*1t8Pt/*/)c3==_cI",
      "name": "@Unit/Variable01"
    },
    {
      "id": "su+pAsx.azc/Zil(giz2",
      "name": "@Unit/Variable02"
    },
    {
      "id": "}2#IxsnoF-!0#i/I7MBR",
      "name": "@Unit/Variable03"
    },
    {
      "id": "M?N7dX^.oQa-889CmY0|",
      "name": "@Unit/Variable04"
    },
    {
      "id": "gtulgSwXW%Z;Ogz/t-EK",
      "name": "@Unit/Variable05"
    },
    {
      "id": "bbCJW,.MZD5]$@:z[@)X",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "9E|?MngWBbM8q:7g8mwR",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": ")}(mJ.v]K^i}.xr{:7bg",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "3Xv+VXh6C#HgjIEe4!ib",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "$=5~z4`FG!Ad+Y4A9iL9",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "ln(_ug,zb)c{RY=aOXy:",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "[_IWv8-sy:CwQ}PIAKos",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "B}}LYKqLlVivt,-GqAyq",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "b]/fqfUhlM])m{f%NsnH",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": ")(Vbo`D+}C4kK23HUN~}",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "S!.:lPJTL=nkQpIt#EjZ",
      "name": "@Map/Variable01"
    },
    {
      "id": "u6^@zYeaBLGJx.N[n}?L",
      "name": "@Map/Variable02"
    },
    {
      "id": "CDKPyZd:E(Kd+Nr%GW~n",
      "name": "@Map/Variable03"
    },
    {
      "id": "|o!T)AvCEg+@!YSns-G8",
      "name": "@Map/Variable04"
    },
    {
      "id": "k/x6J[7PxlQI^K*9kik!",
      "name": "@Map/Variable05"
    },
    {
      "id": "Bp-/j}eFx/_7R=%O(AQN",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "Ubu@3UwlAkTH,h*q!Txg",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "L*b%[`CcfNF07mul7;`X",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "~E9$YwI}3YjR_-;,r@zS",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "69zYg}S6!0X3,*ExR=T[",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "yuXr6nwcK}Dqv_][sWEv",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "Eqy$?nRIQrN(jz2}/*HS",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "D+e$naz-qh*A00+snFzu",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "9}L]4@U4(s#z%}}0HvcF",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "EJAT[q;DxRH7:5G9=`,}",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "wAS_nV0oUH;3H*7m2)SB",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "=LXSh9[H4}+|hBQ(En[M",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "$NaPs4EJ.SMS`O}z5H(R",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "[%[FV9TinX!*/bm/7D*T",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "`@|PyU|c@(v(q]K452:0",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "SFfrmA0[~aR?CN4M-J4)",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "p=}PTNXQ0BcpOB=i-Cz5",
      "name": "Map/IsStart"
    },
    {
      "id": "y+U]=Kq_3XSd;kZ,ltz|",
      "name": "Map/Wave"
    },
    {
      "id": "x}$fApx@qd5Y_YiBb8F8",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "BnXc7WLj)-HbNM6WY~;L",
      "name": "Map/IsClear"
    },
    {
      "id": "@Z3]S=Ql^:RWV$#N!Sj`",
      "name": "Map/Wave/Step"
    },
    {
      "id": "H.]1?JKr{ILR5UV+x9_,",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "@NT3n4w1KWe?o`Ac-_2#",
      "name": "Map/IsSpawn"
    },
    {
      "id": "jh7#TD9ahXcXkXq(;+?h",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "LZ0e!359c.:[9Ka7#}Kx",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "_4a3q!LrqB=.lNpzeKO`",
      "name": "Map/Wave/State"
    },
    {
      "id": ",^dC`ufx)~^=~MKPoQvx",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "4dyG}[b%*s+}+s!D={LA",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "Nv=ok/?!(mv~wKkIjxLD",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "[XnYgi#yFOa)%-;RGYY;",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "qFD@_/]3uVC38l^SY,{x",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "3aQI}Bw^lT9kg*]jQF^W",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "Zr-ee02z.NZ5L_@8E_X(",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "}`/J.6q`}9q.aGut9~S1",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "aF#MPX(rAH%OA)|,jKHC",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "dEi?*5qLm*GqdN}hp$`j",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "]iqk[F6/${0J|/EV*kU0",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "Xpjh$S-hO6tz+JB0X}%E",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "=gE2.$KwJ4/~G@t]#lBz",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "F!Q/sreg{08b-`_n$z;@",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "57S~,P7vh!4}(!mJ^_-0",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "(BDP{YcN*+B]~h2gN=)e",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "uV5?F{5#v!!wsgZ*-I=O",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "2,(~5BBDi5?u{0$=%r|+",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "1iWX3SjC|EfD[3jAO^=I",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "8WPFB:l3VjY^O(rj-2/d",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "ULFA:TGu5qSKjE|LT?bj",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "btLJ*:E9:GfcfdOnnKIF",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "x3})+:7Uzx2mvw~n+DOs",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "UeK5k*7O7zrx,g7*`sg|",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": ".@8J[?RImet2{TGoG@f6",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "6gTYSxg6M(C]%x1iO9te",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "NSm|2sKva[-k0$t)}I~`",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "@*.1bHDfoIlH?ZtClERX",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "w?EG#t%]/]RwSps;a^p0",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "#UE9%dhZ4C-qAuo+[$qc",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "CYoyGkuBt=L6G###E5(H",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "L!OuF2o5J#P}#DK?Y9fZ",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "V@qG/[`TRJiN=DIM,`/2",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "TO{UN.[zZET[vqad2`aD",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "~wY9ly3`:MYDRpxXUXXX",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "MS,pdSDK%DPa_}NP*L3l",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "MhnX*u|e1Nd?k,jWTM~E",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "W;I/fQN1|QM@ug})GMTV",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "|iwZm+ifko;4nZt8,4?7",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "q()Hl!1I^+Ct8}Ganr:2",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "6NG$?jsD:t,hMUy(FA*i",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "{tT[aFuLz4ZP8WsdQ_vh",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "(}Tx$41(-bKbnna)]1P/",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "ivA$vC()F/W|Oo5Jx=qW",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "2Wz|P{Z?wTvq#A,(A+Ou",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "e5.w7y!K$:=0A9Ib=9@6",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "GhB[3Q`,MzJAoj?Zw]mB",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "!D)6)5q+Q;;?lnQFC+Z9",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "[F)U`-.6._)Pni%fZHWr",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "c_%LVO6swOCR?vve$M{.",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "q;^FJ9(zA|EVHk}vKH%p",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "q.N!:@c9VXJYw0k{_f8l",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "Pw*`8n[X[Yo8oXpdK$`a",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "OJ%v_vn4lCHudqVJ:X%^",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "c_O,SQ6xH)5am*gS9HBy",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "R`,|*A8LST;j46k{%NE{",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "*7|paYI]*5pnOZE2]ZCY",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "mK+v:?)!~b4b:)6`8[?/",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "jK;Q+(,0nLFF]m1}G=|c",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "tNchP2?HVieSpJ!KXmr$",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "k]Uj(O.0ShBwzyOvB,,a",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "#V(=k,q_:E9WSKNC#nOM",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "c}{g$Zi2Smq^WALRoTC,",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "FOG-p?C_#s2Wj)q5,,Kj",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "D3i:2px((SDYpb{FDbdx",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "#]yOiwEY+W7+0++4QcV8",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "3vP;rOjew]2W*O|l6X%F",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "YRAlTo8uz)|=AP]:}2-c",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "JkVz:vhV.#K1%!^j*#YY",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "X2y1{O-]Q/1g@eSw9HiD",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "`_6(=QhamL?PU`B:x9p}",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "!yohGXaEWxd+%a^=$361",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "}V9m@Evw%ud*gOJ+:G[z",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": ".$xP#_pyxPA`|Kq;pudu",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "X5~RD-H)stX2t^0DmOPo",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "GttbdVsn^{[uDMtq#gR/",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "+nVF{G-#^tXmJ+6^`7{b",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "=wJ)s#).6yIav-`!t[*}",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "VkK%OmZVJ6-9UWv:xTdY",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "hf;)n?`[h)+cOV8byy%C",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "q;(qRifmd@FZM:,6/QIY",
      "name": "Map/CanStart"
    },
    {
      "id": "Fi4W)7mB=n3ys{2UHg3(",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "oF$7T.2*UUah-|web/kZ",
      "name": "Map/Player/Moving"
    },
    {
      "id": "wJka7Y?Kq*#rXg).GF?A",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "]pE-]Y4o):E?AF.baMZk",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "xff8]-D7aJPa/|--LH;5",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "+gM4Y%G46DPk)49v3mJ@",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": ")JZxoXF2X[|BCMjF-VY1",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "`SBR$KW)a$%N,^rTr.Y:",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "$n~-c84cB{aS^iL/;#IS",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "g+yxDm+_sbQ:NO2P[cUv",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "iRP^=M*9!4-aJD3~oVZf",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "B(rpc;pp0!]SfH,ot+9?",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "*+$GR3n@|5htANwM}m-3",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "qh57mdOOx?fUUt%ZeHiX",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "4WHQ@Uuo;d5jMO-!Dpe!",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "o0hCb}-xuuv8[j2upwNs",
      "name": "@Map/Progress"
    },
    {
      "id": "ce;~8!w*LB[w?{|@r:K/",
      "name": "Map/DisplayWinningTeam"
    },
    {
      "id": "lR8MJz{WaprwC1?BNE/y",
      "name": "@Buff/Variable/07"
    },
    {
      "id": ":s#rW:`E#nt6MgHE7d,|",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "n9-z~v@v8IL;+Lj461LY",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "%b`ft`n,Z-B%klVblM%2",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "Hs;5lOV(w/vP_om[l]0W",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "?*[3Z*V|@@!k6m!`55LT",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "Q2^sI|;L}diD$6U`RAA#",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "oq,20d8=q$usI$~;Z$~G",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "SBToUXC[mk|;]WY65U@g",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "1z[y4YjH;Pir?N,JAgK6",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "BI+oJ%t6LQGJ=wN*m9G+",
      "name": "@Skill/Variable/10"
    }
  ]
}