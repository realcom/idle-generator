{
  "blocks": {
    "blocks": [
      {
        "id": "*+Y=319VqKfpS6lfjMM^",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"5\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;},{&quot;comment&quot;:&quot;PositionX (default = unit X)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;PositionY (default = unit Y)&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;DirectionX (default = unit X)&quot;,&quot;name&quot;:&quot;DirectionX&quot;},{&quot;comment&quot;:&quot;DirectionY (default = unit Y)&quot;,&quot;name&quot;:&quot;DirectionY&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:UseSkill",
                "THIS": true
              },
              "id": "WiXZLqRmLaSHGlF%~1yk",
              "inputs": {
                "ARG0": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "qg3fyd441baIgR%;a5,?"
                      }
                    },
                    "id": "G.e#hZ181l:*3~ORu7)x",
                    "type": "variables_get"
                  }
                },
                "ARG1": {
                  "block": {
                    "fields": {
                      "THIS": true,
                      "VAR": "unitVariable:TargetPositionX"
                    },
                    "id": "2Mw{CC[WcS_fvNCGTIE~",
                    "type": "variables_get_reserved"
                  }
                },
                "ARG2": {
                  "block": {
                    "fields": {
                      "NUM": 7
                    },
                    "id": ")e}[TwM].r30ZA2@;4L2",
                    "type": "math_number"
                  }
                },
                "ARG3": {
                  "block": {
                    "fields": {
                      "THIS": true,
                      "VAR": "unitVariable:TargetPositionX"
                    },
                    "id": "Wlrvze=|pSj3c^;`U%8$",
                    "type": "variables_get_reserved"
                  }
                },
                "ARG4": {
                  "block": {
                    "fields": {
                      "THIS": true,
                      "VAR": "unitVariable:TargetPositionY"
                    },
                    "id": "}{NXQC`o}IQ/@}D!?it=",
                    "type": "variables_get_reserved"
                  }
                }
              },
              "type": "function_call"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "THIS": true,
                "VAR": "unitVariable:HasTarget"
              },
              "id": "F7i5D:;E(8`3m1xtv;TO",
              "type": "variables_get_reserved"
            }
          }
        },
        "type": "controls_if",
        "x": 335,
        "y": -115
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Skill_ICBM_Start",
    "period": "0",
    "triggerType": "0"
  },
  "scroll": {},
  "variables": [
    {
      "id": ":{wKcbxzQ0bh_6`4O.;G",
      "name": "Gem"
    },
    {
      "id": "1T/.uH#1.qJK43T!$*x7",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "qsCdlf.,@/U`1=E5H540",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "of/@*{.*mT@mMr/:Bw9g",
      "name": "Unit/Time01"
    },
    {
      "id": "_Yr6trOK(IM0m^Ms:qKB",
      "name": "Unit/Time02"
    },
    {
      "id": "thE(^Vp[t}N]-@,j~U[n",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "=t)6hqh:Mz:%[dE5H/`r",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "|:9=^CJZ:}0[3TxfAZcz",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "ORXtsm[5mR4H$`b7dPiQ",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "yq#A3c~R9cEq2dFjKxoE",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "}ygnXRllyPunL2|P:sq/",
      "name": "Unit/Tick"
    },
    {
      "id": "aOv]?a#^4I_/1a[t6N95",
      "name": "Unit/Rome"
    },
    {
      "id": "d3B9z0HomZ!ncr-GQAXu",
      "name": "@Unit/Delay"
    },
    {
      "id": "~Narn`J[`AIJCt}nz7`!",
      "name": "@Unit/Range01"
    },
    {
      "id": ")Jnho_{yMs-(7X)ipn4?",
      "name": "@Unit/Range02"
    },
    {
      "id": "]r37AVQ,GLbzoiA/{,bM",
      "name": "@Unit/Range03"
    },
    {
      "id": ".q+`_g9mf|~6ePc+}P2s",
      "name": "@Unit/Range04"
    },
    {
      "id": "!@lf|/^*uxMnFPM)D-U^",
      "name": "@Unit/Range05"
    },
    {
      "id": "/|pBoWOs+!A34lFq4Wex",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "h=ZLJozAS:Kb:mIITJ1_",
      "name": "@Unit/Variable01"
    },
    {
      "id": "!M3L5frE!b+)6~H;)jo1",
      "name": "@Unit/Variable02"
    },
    {
      "id": "4b89)`h9s4T-5=UOQR@,",
      "name": "@Unit/Variable03"
    },
    {
      "id": "g22[[UGY%{3$W%S`L]pc",
      "name": "@Unit/Variable04"
    },
    {
      "id": "8{dbaoB`I*KX#Aj.O(fB",
      "name": "@Unit/Variable05"
    },
    {
      "id": "uLY#9@vg-+OqZ~jDE8Pn",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "D_H`)4jc?[x[jFL}Y8h;",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "Rp|R)i*ON=PX,/%rWV)S",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "Gzx3[z^=~NdlRv+|0uPG",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "L!akfI%v],SUWl{4v#P7",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "cTm)DJ853/x;,m`nh?BN",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "r+hex%l?UR0K@:P%+xbC",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "jvGrk_B?+t3L6gWMX,|v",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "#Z@T^px_0r`PiACn(7N9",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "I5^l8T?1!-}DHn~5%B$Z",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "0/)u/Op1NahEf}V0*zJ/",
      "name": "@Map/Variable01"
    },
    {
      "id": "-aK!UliG*]7bonXpGBu2",
      "name": "@Map/Variable02"
    },
    {
      "id": "bszhE;DhkgPv1!T);Lah",
      "name": "@Map/Variable03"
    },
    {
      "id": "~Akg%A9j12.{$fi1ys.J",
      "name": "@Map/Variable04"
    },
    {
      "id": "RW)A*j7A2o={vYYfa$m!",
      "name": "@Map/Variable05"
    },
    {
      "id": "!%W3tuq$MgUc)QVT]Bc;",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "TXF8iJa5s@bxYPbBJRR4",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "r5p1ymt#HQ2TgPqGJet+",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "x2?tFWYfqpemLV,~(0xx",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "Y]k%37LSTSE}dLm-UUB/",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "JPqMveS|Toh]9q=PZPWr",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "XTt8D9Rlz*IuxUEl(WS,",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "_fBJ[EZGe|QDkl@Fc3R4",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "_t/#7P.](,-b-Ge.y)g3",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "Ovqm0A5{TNkj2XBJHR.p",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "^FYps#9sWEg8t~cil9ZU",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "$k1E^]kY*eCg[SFA^zpA",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "N{1KQz9VyD}{FY}-B_|d",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "buqxpXlb2;[bCgjJdM+x",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "]`OG!5sFl![ucdbp:Fw]",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "nZZOU-(0r#s?@O/tefW[",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": ",[z],eo4kdqaa[#lV;h.",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "Bjy;dXw5:=JPv8]/6Ykw",
      "name": "Map/Wave"
    },
    {
      "id": "Hu}oEkPzVbez#XGtCRt}",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "^U$v$A%^mwk%,Z0vklEu",
      "name": "Map/IsClear"
    },
    {
      "id": "N9Qf?)^[O2WTI$*LSSyb",
      "name": "Map/Wave/Step"
    },
    {
      "id": "]kFGHKLp8-vMCs2kbv#p",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "I2ML23NYUi7{pQhCE/s1",
      "name": "Map/IsSpawn"
    },
    {
      "id": "DJTJGF(c-vvo}[dp)%O_",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "?HS}{pI|^9d^YSHbuzk#",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "tgi}0J`:WAwAhE},_!0k",
      "name": "Map/Wave/State"
    },
    {
      "id": "3dOOUQEV@{pJhkVv?Q,!",
      "name": "Map/Player/Moving"
    },
    {
      "id": "?w4]$8K;SxUY!Br+,*?{",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "s37h,To3SH],V#_SIVw^",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "vqxyr?$rx$RGHo8k7(sd",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "}4f4Mwcrb;,^bQLLK1GB",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "*nR_Ggp3ZFcJ~OrH8~:5",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "#}EqPjFP9??npqT#=W3n",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "WYb}E6(B]r$j=e(.99##",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "~gU1cVpNKk,[w9N%xQon",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "~_^A%Hb#?KD?U6c7WRb~",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "{xBgSt%xN^+3RZ]vFh7p",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "`y8BIpU@/vRUbFYL8)/m",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "dVeV7wvj|nY/S9v;(q:]",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "#Gm(6CV!gt}mEJ#c8W0x",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "Fr7a/yOZ,^V8N5^`vZ04",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "x1+NE$g3-P;j|e{ybq`n",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "zA~HW0(qpS@)SF1cwj(3",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "^I4v1dB[C?tw9;Q[bJSW",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": ".0r06P;J[Dr+Quu$5dvt",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "!GJU$oOmfjXe*0mdCtg)",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "p8%:|5Ts;VE-YV@K@/Ry",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "Sau%msW!;3bttJ$|^(ha",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "qg3fyd441baIgR%;a5,?",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "ud[]DUbN)c+R(#LL.80F",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "L;J:K9!gBNOTBRoe}ll=",
      "name": "@Skill/Variable/03"
    },
    {
      "id": ",%+Dn-LR/HdD}V1ZI_Qd",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "j_T25^JIHq3[jgXHQ6dX",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "f]JNpz?K)|b7Z|.xW,+u",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "qu5}-MajJwTTl,%fe#xX",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "JcIV/zV6fg/pzHvM)-nP",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "$:-l*6?p|l(jwelwaC:N",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "M@_2PC7BQ0@DUor:8:Kb",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "jidnh%tv6tUp0HeSe]AN",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "Mt5cemzy_MdjVGo[x{VD",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "Ig^[;.OAIny]S]w:)c.9",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "-[bbzxpthnT+)puhk{B.",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "-?I$@?=,-`hsL+xF`Y)%",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "6kHbeN`]OwD$Sf4(wW+,",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "yqJBr^I^}-+?E1Z@FmUb",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "!#KJBgIi|xGhoO^~Ah)G",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "MG/$v}Q_@i~__n$wdKjZ",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "PqfWVlx*C$4}r{tgqg$`",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "#(f}bJ0CYMj]|x[l]cu(",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "qgvT,`(+//{kfCRJd*J8",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "pZuKO+ASEUx[a0{x%j{M",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "n18Tt~{`{`51i(+XQ-Ia",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "+;sEkMeBMk=ObitF6c33",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "KN8pi`u@USH:K|rp`jqc",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "yPp:[O6(]Rl%C]6n][Y=",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "(veTWM[-T(B/?JOW$;TN",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "UOeQvY*j8`b8v^3nDWP:",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "=RUkx2T-:M)ec3[[g;t!",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "*JGKw@ZLMCHs9WxLr1n(",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "rmTMLW|stShr)*Fwpp[q",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "NBVtGU:%4/7b)hEDqPUO",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "i[SPikIr0f^I%E2TbBak",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "Q2%/Z-Wqd2V5BSpVJ{hJ",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": ";lS#1Na9hSwOgHs;{Wu#",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "NI.JDdo)q-z1^08z~nMP",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "TnBn%f}41B)2!5G!VGaA",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": ")f$}1FUHZHwek|zpJaC~",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "WbDv%|8z7mT`Pn))Stko",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "VwV8C3W}?C}mNp7s$gAX",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "uhL7x?auCx5Mp.Nq[!Pj",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "p*Lz^$P9cDXEJDcij+$c",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "IW)|x9kUQ4Wk[T^rX/Q!",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "yl}GN]BL:KH*v`JLe|sN",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "4v/Fi_YqT5HffLO5pv,I",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "Ueb,,.s,}b$ZP8E9Oiu8",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "*0l./7|epourThaso0ww",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "-=~t3CCIwUB5q4hnT(8]",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "g_~0nnshY2*}#+G5F6[Y",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "ViS}Ddy%Y*o-0q*umVk+",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "?22=lcZw(m@^i`L=}zxh",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "ZRS=6/wN![MH?5h,rJm@",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "{[chU0*3A~GFT3zh?6}@",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "`=}3!(^@xxmopgcG)M^P",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "1l;V+IWTwrkR(ZV)CYdM",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "|y:{M|uRCnZqnKdc1n;k",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "c|buz[pGE}?IUcGVShkR",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "3]ed%v[VE#7;`r.`!87[",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "b.SWyE!R7~yoyW#+.uC%",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "zW*DOT(^pU$[ZWJ2yUeg",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "HN2`98w:m!BZn:xNT1wn",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "0eCeFsgYs:`KNHL1A0dx",
      "name": "@Map/Player/InitUseSkill3"
    }
  ]
}