{
  "blocks": {
    "blocks": [
      {
        "id": "Pv,7#.oj7UMHzzwv@;Cn",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;slot유닛 여부(1=slot)&quot;,&quot;name&quot;:&quot;Value&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:GetBuffByDataId",
                "THIS": true
              },
              "id": "Gpu{D:~!(B]rPWO)YuI]",
              "inputs": {
                "ARG0": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "_dH@ZA_|{2Nv|kTRYa}V"
                      }
                    },
                    "id": "[}_H`BS3zxcyVgn!{8+s",
                    "type": "variables_get"
                  }
                }
              },
              "next": {
                "block": {
                  "fields": {
                    "THIS": false,
                    "VAR": "buffVariable:Level"
                  },
                  "id": "4v?wU~-wP7o.egnz={Z/",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "OP": "ADD"
                        },
                        "id": "G!r20@9)a#Fr9$esL/24",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "THIS": false,
                                "VAR": "buffVariable:Level"
                              },
                              "id": "~j6Np?_^$jG#VjCf]`M|",
                              "type": "variables_get_reserved"
                            },
                            "shadow": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "5i|HPEF|5lC-DjcUjn0H",
                              "type": "math_number"
                            }
                          },
                          "B": {
                            "shadow": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "4;bL~%h(Y%K#?}+yaDij",
                              "type": "math_number"
                            }
                          }
                        },
                        "type": "math_arithmetic"
                      }
                    }
                  },
                  "type": "variables_set_reserved"
                }
              },
              "type": "function_call"
            }
          },
          "IF0": {
            "block": {
              "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:IsBuffApplied",
                "THIS": true
              },
              "id": "iAe6AmZTd}8s|$j*-Zwc",
              "inputs": {
                "ARG0": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "_dH@ZA_|{2Nv|kTRYa}V"
                      }
                    },
                    "id": "lQ7m9T#a[{tUY`;+uMYB",
                    "type": "variables_get"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -985,
        "y": -905
      },
      {
        "fields": {
          "TEXT": "철의 응징 발동 횟수 당 공격력 +2.5% (최대 50%)"
        },
        "id": "g:L{I@()|{Wx$TsVJk/t",
        "type": "text",
        "x": -965,
        "y": -1015
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Skill_IronRetribution_Start",
    "period": "0",
    "triggerType": "0"
  },
  "scroll": {},
  "variables": [
    {
      "id": "TCQoou3557%.KD8ES/(@",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "@m[m0biHafwE7Ujp4@8*",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "3R|:;?__2Fjg4]lko-O1",
      "name": "Unit/Time01"
    },
    {
      "id": "#`IJMk~KLMTWI,1c^cXC",
      "name": "Unit/Time02"
    },
    {
      "id": "^@=_s%T3RZrR$`hpOQ=d",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "RU@~dX?)tki+b)l#L!5i",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "3GF{pax)NgDek9JFJH9b",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "@L%5{|A$NAJOr|KC;Ja[",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "uJb]^ROrDupgQfWBn7dy",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "xB`OQML)CUCfOJc=U8Ek",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "~DNROG2id]Na^QQK}*4P",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "M81/svQtub8;3,5t9^Vb",
      "name": "Unit/Tick"
    },
    {
      "id": "4itqh6=8F@,MnBE}dZ;|",
      "name": "Unit/Rome"
    },
    {
      "id": "SpQ/J+K2c`L3[r:oEFO$",
      "name": "@Unit/Delay"
    },
    {
      "id": ";rxeb$hLG7U*cXFV!e={",
      "name": "@Unit/Range01"
    },
    {
      "id": "bj*wyMLNmx[jG,vxf2X!",
      "name": "@Unit/Range02"
    },
    {
      "id": "r]tL+|7Ms*VZx$j6j3:K",
      "name": "@Unit/Range03"
    },
    {
      "id": ":vqev2PW?gGY2gMlm^0]",
      "name": "@Unit/Range04"
    },
    {
      "id": "QS755nL^oz-raDrC@84R",
      "name": "@Unit/Range05"
    },
    {
      "id": "OKw+KdBMns=Ny6eP6AJ3",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "jED0m{FGru@r^AMA{#bD",
      "name": "@Unit/Variable01"
    },
    {
      "id": "KOvK888y4_KAaqmx/sRb",
      "name": "@Unit/Variable02"
    },
    {
      "id": "q7[ZsmgKn00g7t3l;dU]",
      "name": "@Unit/Variable03"
    },
    {
      "id": ".XYD{]cJkWH_7.POx)O.",
      "name": "@Unit/Variable04"
    },
    {
      "id": "lD-4?`MuSxy:DIHMC.+`",
      "name": "@Unit/Variable05"
    },
    {
      "id": "kq*UT)[7?AC%W=tYgN=m",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "9jEn3m^G@VHZ36Vp#sPE",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "QZ0F?*1_8S^lb0|kn[GO",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "0PNH3+_6y:M95rJXIT]#",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "Eki:OF]MG__BX!G[/jbk",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "(:JWvLezxRnC*%oGXRL=",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "Mqrw*d~9iJXNlhgrSC)+",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "$bhb~W17[]W%S`g{sq56",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "$W]nU;v=TS@AW:T_vHmk",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "4@|xRHQ|X;muRkIr^i:3",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "D?uZ]K3EZjZ7nqG0OJO(",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "k4HaihPU8Aqwm|zD[3WC",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "5@tQ_aVG)c|KnWKE[G%9",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "hN$+in3ZE?2UEmx?,Cr:",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "1;Y9a`C3iZgyA4U6$^~z",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "NTrfhM:0]7~_E68@MqYz",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "O5+q4NssvY^V*_:+X[mh",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "R(B`m?3Y7p4;{]X4VL)p",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "+)cVlf}iZ_*ts:BS9N(h",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "eAN)zJ)2N#`sFhl;_7__",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "%J![aoZO./qO]:S^H@=(",
      "name": "@Map/Variable01"
    },
    {
      "id": "!(PpT0bayu8CW9vYgR3}",
      "name": "@Map/Variable02"
    },
    {
      "id": ";}Y6l{E~q!u$FFp|)aVu",
      "name": "@Map/Variable03"
    },
    {
      "id": "#iGMYV+4xXkO*A2-c~+6",
      "name": "@Map/Variable04"
    },
    {
      "id": "G(L-jkKm$w@/RjCx3Gm-",
      "name": "@Map/Variable05"
    },
    {
      "id": "AY#7)HDG4N}z*Z-B.7Px",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "-U^QgB]ryA6FP$G/XVlV",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "R3bY#T#47^7I]K8zR*1/",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "X919wLsSP}LbDc2ham;U",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "Q8yNLUnn}3Q0vf[.=v=m",
      "name": "@Map/Progress"
    },
    {
      "id": "1anLF|{lyk_w?v5UO|T%",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "hhe,m!Jw:hYueo_z;)%z",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": ";jGvwG?BA$~-1DAvkm?Z",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "[^c*vSx0W#B72r^k9RbZ",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "XR}nS@WHsgQ=M_KV%x.w",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "1[5aa41CMwMSfOaTNky-",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "bNmR`AN!77[Z@MLeU*TM",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "}Il==jSr%#y}[R%C=5=A",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "WLw8|+]5bksh.]}:/QQ{",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "WG;Ku|FMe2hO5~KORp02",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "/z^B0OA[Xf)(gu|3XLE,",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "Bq^FB`{+_kwSWrT%kI)9",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "vH4Xtn0Z=X3w0PI*{#S9",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "{Ug_C_Wjp^65@5qbb(Mb",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "S1;@(GbPj`Q5XK8X(K`8",
      "name": "Map/Wave"
    },
    {
      "id": "q|#Ufg4uw2R4wlQZ2=Ls",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "$S;^x2wB!@d;WK47-gFv",
      "name": "Map/IsClear"
    },
    {
      "id": ")YS;+9(}RBhvvQd;m[4J",
      "name": "Map/Wave/Step"
    },
    {
      "id": "u{Kare/@~[EF#x+MA:hf",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "@:HfVRCNUg|Q4g@@Z[~_",
      "name": "Map/IsSpawn"
    },
    {
      "id": "PAZO|c_:EG_U^-hrth2,",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "[-My~vwt^lI!xiviwW#.",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "B]=Mc-B2:^BO9:#-G9f,",
      "name": "Map/Wave/State"
    },
    {
      "id": "1~vgt(q441w;IqOAxk+j",
      "name": "Map/Player/Moving"
    },
    {
      "id": "L7ML=R5g`=bjNGR8V($B",
      "name": "Map/DisplayWinningTeam"
    },
    {
      "id": "%Rg2Ed:$FcTzuxOMhH4[",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "Y.b^?#`[e6Lo%V@)g`{R",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "hk+rB/]Gp%;Z+Kf#Ea|_",
      "name": "@Buff/Variable/03"
    },
    {
      "id": ")^f][-EN1_+62$QrS@p}",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "XW2Y(%HAg@Rmgj:,PO%Y",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "@mr-rOT5ZZPn6F%Bv[Nq",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "@j$F?8T*L4)pB?o!1qtp",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "?7z3L[9qr4rW5{NC.;PF",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "gkJWd;[jxsbtE_7GwV!l",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "ra6,:9q!%C=q]z+%muU[",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "o5C(zi%EH:Apc{2ut8cY",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "Q;=z:].`k%oL?{)$B0(#",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "m142K}oY=;bpQzGK/-l~",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "XBZ=TJIz8n4r$6-3rtbo",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "}~FL4XMXV[C5@ZP@J(XN",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "[2#-fKP1meazsAT@2{U$",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "8U~s7/bW1VlqJ[-#gbna",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "U}zX}^LY4I),th`,9nZN",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "YnFVKyZ5[|krnj,ZQd/*",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "P,ePU![GET1R15*%7]]K",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "p75e)^Y]ZgCY47b_Q4LE",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "_dH@ZA_|{2Nv|kTRYa}V",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "TsA@yMEicg!S;tsxA0m(",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "fnX(#n,6!dWcaLX|G_ov",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "wVmuu3NS).VHw]sGez_w",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "Zc8$nNL#OeX+B[C#HUV^",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "ZTSSTug#vM=l0;l+m7kp",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "NE1/#![J+fpO`bfV9G[O",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "RkH.D[RPM4aD1,z$9hTb",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "m*PpIBKZ6J``C-ed~MH3",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "6]5*f8B2DVzYE;H`x76G",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "gJ%0^DizHnzE+QhnSd$d",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "zJ8kx}Vy^oUSXGP;2;}R",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "]l7QVCe-dHpLorTFnMLM",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "dP[$vB2vM}g|p`,#@4]9",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "1g.{lq/eEiFyx0i}5Ow$",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "TyiM)@$u)X[Qt}E-+rbG",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "9_sGWxAi[Ryzf0O?WP#k",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "V~}ZuGa++HYFo;iTo#_8",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "`izU+Bgog}zKQhErTt!,",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": ",trG4=bbmv].#C5`Vyy$",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "S;7[y~RJre-(yW[w{Tk0",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": ")2v;}O0|-yWlJhHXlkQC",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "+[9:D.]hP%F|[oDiG5~[",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "%p*;pl@{-_+$-T$*[Gsq",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": ",Uv`aQ;a0-q.X2t5]i)Y",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "W*$Srcb)|5R!HYMOFF%=",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "kmKzmD[U2BkxB8D-1Y@h",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "=z*9La83yV[7:[9DP^V[",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "8sLbrwQYsom}Wja;[g$h",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "HalX}IuPWj-a61=tSNPC",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "$68h]S0KZsFiQo1%;iy)",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "8geKD/^%IS)}4{#i`kDo",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "C/rMtmGc{0bTJUAa!O!S",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "$vbR+Vn`,P-*M-92;yD8",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "Bv(*;=|F_3i)I,R=iUaK",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "~w?`2|VeVnqN8j;NxpK.",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "O?$^QNa:V2D8X[f@NOqj",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "o/4KoA;Kp7A!ioYgYXcY",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "nk2e57?eW,i]$:Yuz`Yu",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "`p2F%!r.NUit6#c[_r^r",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": ")ahlz|*1(Hx$L0JXx(Fl",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "O$9~V,D[vTv5;~b4h4aw",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "$!Ewd[n1HyT!IyV$hi$G",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": ".UJ)`XvKk}z~L+|F*IQ4",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "1Eh!Td9IL0=u3]N^Bw0X",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "wcm#N*/o|9o0]oc^#|#W",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "/d@~Z]ld~:-bI,yLCA3V",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "Vg1$B*5ze4G)F2ulphg,",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "l~gOW~U{^!obdjfOLveF",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "(YVQ/:p]xlM6d=U~`]oP",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "|!q_Om^$F:yBX|x#tPVs",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "[;xj`zRGhEu/aR;0@3Ss",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "*-/xg,b,9i5j}]@:Bm-u",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "hj=luPZKk0snk-PWX!dj",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "fpz/8K+IbB0r4?ZF{Z9j",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "RkWgnd:0H[94Wn8Rf5Z{",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "Rv=(SIFSE?K^wt-8~H%1",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "mxfc935P801b?`+%olU/",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "*^fcyg)(3Q5hGvS-y:.B",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "3D2??(-,bm8)P.(#M;dj",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "..jEDezL0+4fJ[Ajlggv",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "^k=j#?32f9o:i:58^/u]",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "u(0K(}bw6-kMr`[VqC(*",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "VZGy(/w(u.Ohz#O[J|H,",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "0^y}7tgP*LM]-2MkhxRx",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "y@KAq|Bs4+-RhgEmz~(x",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "v90]0.,/V?4%Jf!44R|%",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "4V}@Fy3Uk2xlAGeSN;A@",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "~LTruv(aL}n_uW[rQDK7",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "{GH%U3V4LF;My-)$$~+?",
      "name": "@Map/Player/InitUseSkill3"
    }
  ]
}