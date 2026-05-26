{
  "blocks": {
    "blocks": [
      {
        "extraState": {
          "hasElse": true
        },
        "id": "B/LM.)LHzUnjQ?z/xofB",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "THIS": true,
                "VAR": "buffVariable:Enabled"
              },
              "id": "K{C{Uuu^)_0;v@lV3;85",
              "inputs": {
                "VALUE": {
                  "block": {
                    "fields": {
                      "BOOL": "TRUE"
                    },
                    "id": "QWv}muw2Ed8uZAvK[oF(",
                    "type": "logic_boolean"
                  }
                }
              },
              "type": "variables_set_reserved"
            }
          },
          "ELSE": {
            "block": {
              "fields": {
                "THIS": true,
                "VAR": "buffVariable:Enabled"
              },
              "id": "gL6q$Qs`lL$3DF8{zM#T",
              "inputs": {
                "VALUE": {
                  "block": {
                    "fields": {
                      "BOOL": "FALSE"
                    },
                    "id": "9(82vxF83jv^ScA_t6/+",
                    "type": "logic_boolean"
                  }
                }
              },
              "type": "variables_set_reserved"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "EQ"
              },
              "id": "ft.7rch:o(ie@^bJi6rh",
              "inputs": {
                "A": {
                  "block": {
                    "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                    "fields": {
                      "NAME": "unitMethod:GetInventoryEmptySlotCount",
                      "THIS": true
                    },
                    "id": "+-@cBJ@LlP)%FtkBx9^i",
                    "type": "function_call_return"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "NUM": 0
                    },
                    "id": "Sw`@(gqCXSulCn[03a8}",
                    "type": "math_number"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": -3035,
        "y": -455
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Buff_AddAttackWhenInventoryFull_Update",
    "period": "15",
    "triggerType": "1"
  },
  "scroll": {},
  "variables": [
    {
      "id": "R]_qdl8}6ys!(_LXY56H",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "Z8[|MZ#7{DXj{C}mRMY#",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "jP7~Og7m%Z.P)DW21+v~",
      "name": "Unit/Time01"
    },
    {
      "id": "ZjlU`8iYT0:aDR}Q$-(s",
      "name": "Unit/Time02"
    },
    {
      "id": "3=O%E(ALv%~j=vW).2l,",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "gezKBe8%%B)H0/(hxo4)",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "v$jdMVn4XgDd]Fd56efY",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "m8i;ym}6^l]Fvk_l;Pua",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "frQRb(HC4)W{lO@JOW8s",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "4r5FoQ4{0iyCRw*ZT6,I",
      "name": "Unit/Tick"
    },
    {
      "id": "`0UJT6;d_:cw@OBg^|d6",
      "name": "Unit/Rome"
    },
    {
      "id": ",d;j8Gz*CF`?p7=*DZm9",
      "name": "@Unit/Delay"
    },
    {
      "id": ";Qw(A:4tO(R)vqKn!r1M",
      "name": "@Unit/Range01"
    },
    {
      "id": "@g`4aJ1;M3pJG3V}E3{!",
      "name": "@Unit/Range02"
    },
    {
      "id": ")T9wfEk^GYO23HKiqYX~",
      "name": "@Unit/Range03"
    },
    {
      "id": "$2wYG!ai67o:Rc.L%9)w",
      "name": "@Unit/Range04"
    },
    {
      "id": "lh+=3y~J:|mQToH-)`cK",
      "name": "@Unit/Range05"
    },
    {
      "id": "1RAOnV$?JlL}v:wr1IM4",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "?-4JGSh=O,B%6s|A/~Wi",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": "b:h:$H?{#][wF2;FyYC9",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "#p{r%kFplNYDiO%~M.e1",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "@M70d|LhBAGyxe4ja9I%",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "7`FK$qZ`*{sor`Yi^p4s",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "LS_u#EwQjt|,xCVdzX!+",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "dNQ(kujOyy(]U@7`ci(I",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": ")(PHv*JAU%dcW^;ml)4*",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "DskpWW=]*1qV+Pb=0_ir",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "n;{91THz?.ZPFicEY!fC",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "XQO|AT?)H|46cov%?{(+",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "2h5-l3l5~Fecf=-N)O#j",
      "name": "@Map/MonsterID01"
    },
    {
      "id": "+QqNaL0wzsqkD*/RlZOv",
      "name": "@Map/MonsterID02"
    },
    {
      "id": "vj)6gAavs1jL48]V5?k)",
      "name": "@Map/MonsterID03"
    },
    {
      "id": "w%!I.a/mz[%,w9)hZ~1R",
      "name": "@Map/MonsterID04"
    },
    {
      "id": "^o!BBAJ@cW]KIqE0U^]P",
      "name": "@Map/MonsterID05"
    },
    {
      "id": "J(5a_U4[]l@T#Qfw33|v",
      "name": "@Map/MonsterID06"
    },
    {
      "id": "r9P3F?}:0f^)({CZmt!u",
      "name": "@Map/MonsterID07"
    },
    {
      "id": "Z^~SH9N;HUf0*45-)j-=",
      "name": "@Map/MonsterID08"
    },
    {
      "id": "]]M/LPNt`J|^$/oAf?8?",
      "name": "@Map/MonsterID09"
    },
    {
      "id": "mM31DIXxPU3U=oqU[m:v",
      "name": "@Map/MonsterID10"
    },
    {
      "id": "eHJA/ms*bH1ha!;pOlbU",
      "name": "@Map/MonsterID11"
    },
    {
      "id": "oeP.sKGT{n-x[dpTwzMM",
      "name": "@Map/MonsterID12"
    },
    {
      "id": "OmY}U4L5g3J3w^_@J7aN",
      "name": "@Map/MonsterID13"
    },
    {
      "id": "nL?OkLS6,X#7RF*jL6gc",
      "name": "@Map/MonsterID14"
    },
    {
      "id": "tI}0x:}cP^VBRE[Y#+:)",
      "name": "@Map/MonsterID15"
    },
    {
      "id": "[SR~flBf/qiGQU4qX(~T",
      "name": "@Map/MonsterID16"
    },
    {
      "id": "fF]x4mkrBuOVyaO$WNzp",
      "name": "@Map/MonsterID17"
    },
    {
      "id": "vo[+m.2:@{!WGqsS*#((",
      "name": "@Map/MonsterID18"
    },
    {
      "id": "-~_piW0f5kRzTwAn1t%x",
      "name": "@Map/MonsterID19"
    },
    {
      "id": "Ctl/.w/au4jZ55-nD;H/",
      "name": "@Map/MonsterID20"
    },
    {
      "id": "BEiu2DTgP?+s$0tQNL9Q",
      "name": "@Map/MonsterID21"
    },
    {
      "id": "Fcqp.{^X+K#vZPjsrIT+",
      "name": "@Map/MonsterID22"
    },
    {
      "id": "pd{8MVMiqbn^K.LZI)-}",
      "name": "@Map/MonsterID23"
    },
    {
      "id": "Sj2$Jx*_715=YCbI4,cG",
      "name": "@Map/MonsterID24"
    },
    {
      "id": "PFDWevf]Bp]p$l!vmwrS",
      "name": "@Map/MonsterID25"
    },
    {
      "id": ".}Fzy5U:{f,Tdu+c/H?L",
      "name": "@Map/MonsterID26"
    },
    {
      "id": "8V8J.zi7God)VJQVSs=+",
      "name": "@Map/MonsterID27"
    },
    {
      "id": "CNI+%~-O`w?}qd[Me,YU",
      "name": "@Map/MonsterID28"
    },
    {
      "id": "lcO,KOU9A8PMxidP]t#*",
      "name": "@Map/MonsterID29"
    },
    {
      "id": "IBUsVgV4jnQ|j;0_8~MH",
      "name": "@Map/MonsterID30"
    },
    {
      "id": "Y/R_nbLe$V[8YMV@4j-V",
      "name": "@Map/MonsterID31"
    },
    {
      "id": "9}DGxsu_y@)e%mZ:3,a2",
      "name": "@Map/MonsterID32"
    },
    {
      "id": "a#-?JOm)jMU+/6h+{1)X",
      "name": "@Map/MonsterID33"
    },
    {
      "id": "#mG/9sQ:.Z?PjITX3n;}",
      "name": "@Map/MonsterID34"
    },
    {
      "id": "I09cQ5RVDgAx-OjpAO?[",
      "name": "@Map/MonsterID35"
    },
    {
      "id": "tFf1OEp;p)jzS8;H!8mF",
      "name": "@Map/MonsterID36"
    },
    {
      "id": ";(^Guuvo9@uI3}~*J9)y",
      "name": "@Map/MonsterID37"
    },
    {
      "id": "$^gLRP1mb6I+}IAO1iTM",
      "name": "@Map/MonsterID38"
    },
    {
      "id": "@pB#0A}h/4:V:EuNcm(`",
      "name": "@Map/MonsterID39"
    },
    {
      "id": "gDQ9u%Lb,1G#_/0}*VHw",
      "name": "@Map/MonsterID40"
    },
    {
      "id": "uEWDrq2Uj1z;I.(me`W2",
      "name": "@Map/MonsterID41"
    },
    {
      "id": "z)=Djd13Z/Rq@a|srnjg",
      "name": "@Map/MonsterID42"
    },
    {
      "id": "+H(-F~`I2ntt|6]x`5L9",
      "name": "@Map/MonsterID43"
    },
    {
      "id": "t@MIRpuprmgHN90^M8[|",
      "name": "@Map/MonsterID44"
    },
    {
      "id": "or]w-Pmq;@vZp6lUa|PU",
      "name": "@Map/MonsterID45"
    },
    {
      "id": "+|U`QmexJbL*cvgL(Rjm",
      "name": "@Map/MonsterID46"
    },
    {
      "id": "1rHr,x:D5ZY7afZ1Xy2b",
      "name": "@Map/MonsterID47"
    },
    {
      "id": "8;G[:+HTN,X#(FF4)|rG",
      "name": "@Map/MonsterID48"
    },
    {
      "id": "dn#K0k`8)DT{QAszfZM+",
      "name": "@Map/MonsterID49"
    },
    {
      "id": "-?,`:Mp|l:SE+F#%,8BW",
      "name": "@Map/MonsterID50"
    },
    {
      "id": "WR}{%/v^%(Whsh_#WHWH",
      "name": "@Map/MonsterID51"
    },
    {
      "id": "C|`E%hqN-LvImOO{Ra($",
      "name": "@Map/MonsterID52"
    },
    {
      "id": ";7n?BTf@nH2+5arMI|nq",
      "name": "@Map/MonsterID53"
    },
    {
      "id": "(8x_!AvBF-0g~foDuc$x",
      "name": "@Map/MonsterID54"
    },
    {
      "id": "%a?5`Tu)/1w@!{2,x(Qc",
      "name": "@Map/MonsterID55"
    },
    {
      "id": "K2lT8?6??2t%)8rY`F#J",
      "name": "@Map/MonsterID56"
    },
    {
      "id": "1Tz#EklR?}`Qy5Vq(9?~",
      "name": "@Map/MonsterID57"
    },
    {
      "id": "cfMY~A?8m7+KajU}0uoe",
      "name": "@Map/MonsterID58"
    },
    {
      "id": "LH1yL.M4OB,%/O5Q3B=6",
      "name": "@Map/MonsterID59"
    },
    {
      "id": "TKo3Ji%ApMT~j%|6V^]s",
      "name": "@Map/MonsterID60"
    },
    {
      "id": "j+ZrzMtMS#bY[Pj?~pLe",
      "name": "@Map/AddBuffID01"
    },
    {
      "id": "-eAcRvN{UYB3:%8zzuI=",
      "name": "@Map/AddBuffID02"
    },
    {
      "id": "#m*aY%AQt+[OZI6z4--V",
      "name": "@Map/AddBuffID03"
    },
    {
      "id": "l~4576izyK)APYe.g^Pg",
      "name": "@Map/AddBuffID04"
    },
    {
      "id": "/-ntygXw41[PG$y]!G=@",
      "name": "@Map/AddBuffID05"
    },
    {
      "id": "M3-7Iy@Zo}TF^l!{R=:K",
      "name": "@Map/AddBuffID06"
    },
    {
      "id": "|$jDps#Ew`|nx7%EGH%B",
      "name": "@Map/AddBuffID07"
    },
    {
      "id": "9{h|BrDkTI8lr`wl79^G",
      "name": "@Map/AddBuffID08"
    },
    {
      "id": ",IGvY8m/~kogTEIaU[y`",
      "name": "@Map/AddBuffID09"
    },
    {
      "id": "v.nj8`a}N2|X@|N,WI;@",
      "name": "@Map/AddBuffID10"
    },
    {
      "id": "?kL(C{V%39RXs+^3,(Gr",
      "name": "@Map/AddBuffID11"
    },
    {
      "id": "|p,uWx~4m+~!U{x(~bW|",
      "name": "@Map/AddBuffID12"
    },
    {
      "id": "$$!.ZB87/U-4+CdsR@aw",
      "name": "@Map/AddBuffID13"
    },
    {
      "id": "bFbT4)Vg7qMhjI9bo~j?",
      "name": "@Map/AddBuffID14"
    },
    {
      "id": "jJ$@_aJCJM|#gc-R,9YD",
      "name": "@Map/AddBuffID15"
    },
    {
      "id": "$o]p_V.yi7j:E:Pi*dIA",
      "name": "@Map/AddBuffID16"
    },
    {
      "id": "qE4nKAO-6KU+]]Bld/+9",
      "name": "@Map/AddBuffID17"
    },
    {
      "id": "]+m41Q~x4XZPl1lb.aI%",
      "name": "@Map/AddBuffID18"
    },
    {
      "id": "lRYG63%psfL7%!QDR!a)",
      "name": "@Map/AddBuffID19"
    },
    {
      "id": "AXR1d/Ni-xW=g?e[$^tI",
      "name": "@Map/AddBuffID20"
    },
    {
      "id": "3lcVY~zCpGX2%2fo@lMv",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "[tbFSD8J{U[tgG{Hq1E]",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "maR7XO}7V.F+gSR=wTN;",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "4,.LJ?)e{wiQfm1~=l9I",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "k3eP8Z?U95Tp3aAwxSix",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "]=xU$[D2?qQ)5Zi/|Kfj",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "Gw?_F2zcfDHI93!wo6oJ",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "cBZ!!q,;););Bs#nF~;)",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "Te0kQa+TS3RmXtiOkyQ/",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": ".peR8S,[z:F(aaJ3`Ob_",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "#lH)naIL%Ip[z65F0gIQ",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "oBc`}ybd32LrcV;a]|S*",
      "name": "@Map/MonsterID61"
    },
    {
      "id": "8}.}W#4SDrx#%*~x~RJI",
      "name": "@Map/MonsterID62"
    },
    {
      "id": ".1QQ%3!dL5L?vPTtz5BM",
      "name": "@Map/MonsterID63"
    },
    {
      "id": "[dHR~NqTs%pra6~pK)-W",
      "name": "@Map/MonsterID64"
    },
    {
      "id": "~KY/m[?uu|u){SHFhCB`",
      "name": "@Map/MonsterID65"
    },
    {
      "id": "EJYl8]qUaG$Ad.bV^Ql+",
      "name": "@Map/MonsterID66"
    },
    {
      "id": "7)}1prZ1EkO`QCpho.wh",
      "name": "Map/BattleValue"
    },
    {
      "id": "{k+,Ed%3v-7,r77WC:8n",
      "name": "Map/IsClear"
    },
    {
      "id": "u1ES7M/ER#)iu2g/R;n~",
      "name": "Map/WaveCount"
    },
    {
      "id": "P7(WcFXfdVb9mvh`y3Qh",
      "name": "Map/WaveTick"
    },
    {
      "id": "yi!l95cq^r:h_fLx@2q^",
      "name": "Map/IsSpawn"
    },
    {
      "id": "!=Mcf~5*(N=U_(BTqO)i",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "W?0Mydl|8tFf}5eY2@7,",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "vf/NG^wA;a%e=JNbE..S",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "Kp|QU0FlR6kJVX4mM/9;",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "`Ur;Zq~onJul-x7Tdvlq",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "XmvZ:Y_$Jl%@$]?:9IIx",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "QC-l*(`%k7(5!k[K3gFS",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "KG3y1p!*9O+0SE*%8PQQ",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "K=k27@c?i{Y@-BjWq6[C",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "l;CJa+PRWb~K%c#4!,):",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "}%{L0!oVD-[6P_QGHyOy",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "1eV%s*^OG=[g|8ghzkN|",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "6fArmk$/Pl%C`|I)6*E9",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "|7|tergn|]jesM!NHPNj",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "i`k=UlId!J-lU/C+zg!Y",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "a-TUnY0Mvu;;4B,Xs^2@",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "I4u9W8$[9v1U*MhK[.Sq",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "Ws5*u,z0~uB)N^8-Ktya",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "W)SRUpZJ$BZ~k.*cRtxM",
      "name": "보석 상점"
    },
    {
      "id": "oo+r2paBZgN;)X,3PJlw",
      "name": "@Unit/Variable01"
    },
    {
      "id": "OUdzsyd{]j4|P]W,8|vi",
      "name": "@Unit/Variable02"
    },
    {
      "id": "3=Z45r2AOc*gJc)G6SJY",
      "name": "@Unit/Variable03"
    },
    {
      "id": "WdkQ.UtX^rIWXPJthg.~",
      "name": "@Unit/Variable04"
    },
    {
      "id": "O{asyCzzkX~S^k:*1(51",
      "name": "@Unit/Variable05"
    },
    {
      "id": "cg)7_79Jg$!3q/20N*y6",
      "name": "@Map/Variable01"
    },
    {
      "id": "V[AIiOb+-KInI6=qcRGq",
      "name": "@Map/Variable02"
    },
    {
      "id": "KU:hV177quWt4T;s_SY!",
      "name": "@Map/Variable03"
    },
    {
      "id": "!6.6MqT@gZ`oRF^=A4:-",
      "name": "@Map/Variable04"
    },
    {
      "id": "Ku6pa882z,:m{i?D1+!E",
      "name": "@Map/Variable05"
    },
    {
      "id": "(T7DUJAn3jWv#8*?NS;,",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "AqW.`*??P3L$YQ8Jr;=)",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "+Z.Amef,W:@l*4!*iF-X",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "`e!Wco5HcFvQi)8wx5v@",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "3L1{i+Yv4,^r`ZOwrN3^",
      "name": "Map/Wave"
    },
    {
      "id": "a.YdXZk5j4YpT%;/i$g.",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "-!NXIUw5@|O?DAu),Tgi",
      "name": "Map/Wave/Step"
    },
    {
      "id": "1joBY;qAKN5*S7AZj*@D",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "3(}[4RwE8-FAI|y@W}f`",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "L#HjN$nGB-=bUzOVh8-c",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": ";m2n|Y`DSh7@xz]3,|41",
      "name": "@Skill/Variable/01"
    },
    {
      "id": ")|}r%*)0zFTwT.W+-h9#",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "LG_vlF4/a;TU/OS}~wAI",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "?7bD^rXRS3XmveH]M%HQ",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "sW!m;5N~zVKL(y~FTs=q",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "8gb3x#aUaefMuoJG`pbP",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "oBe}|kNX!O7IG8v]fOM#",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "i44!0}n}^Ygg}hx`FPyF",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "G`b?^v`Iup}UBDyd8guh",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "a6i)60ef1tg|IanW%!K=",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "Q0^EoTjl$R0OGYv}t[]J",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "D/V@G8O2_FZ~m~e#DC~7",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "YH1Y2}j[cR,YvAI|F$j~",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "s`Q_K`).1K)3IcYP0FY5",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "{T.)~t-M;h[^)(~I$MT3",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "L8W:5r$zNT@p..@)MLL7",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "o3:S.L~eDga%d96n_Z6=",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "N0TtT*u3u*`h/@m$r.Hv",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "89~lK8dNIK:dD,l8XG.%",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "9^5z`3;yYI`%/X`No~Z5",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "K4U@a.6@efU%%a9~`q$5",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "/U=QGABsN:*IIDi.AN:x",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "o6_BcL0=]O!-?h1zycpH",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "Dm8OEE7%Lw+f/p%hvcqU",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "DyJpWeMccPgauJrpRElz",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "FJju_-msW:vtdz5]eV{1",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "LXQjCG^OOEH%+lEAj:x#",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "zI/`p68;OW#|{r*^feMs",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "#]%q9)laGP+6$l64?.i(",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "n+rF{%KnZR%?y3KCu?fo",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "Zaf``gZObOZDT7g_w+Nd",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "]UC9H0s$c]fqe*1*zw%d",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": ".MhHvE217L3qKsT$+x4U",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": ")N[ejm?x{XCQ3r57oNL*",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "cj.M72S-Z(^q{TNFacn=",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "^Dfv=q~yxIKnu62)r{[(",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "s!g`e8z0c{!hiR.BVO^W",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "s_(dnFJgm$l;}cR2jbpK",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "TV6-c#8TpeRI.-r3r5yZ",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "^jj$_*@vtLAe@4d={MzB",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "ng~InH-82n*o.,6$fo2?",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "E6!1AIan5z}.Y]v:j5JG",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "eC_.RH7K-W@#Y[UwJ9Mo",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "m2J[$w-3W*)DLJ_qfE,8",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "E7]++4i0O)b_%WPHo?=E",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "Azhl7S8hE={H5luCIaf-",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "W;W97/!yhlP|H6p0GHMG",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "?(Qq{]MU,*1Q+i]o,x]6",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "}[oi^~4d=*y$$6m^`-%#",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "^-/mmY2EWswFVTg!-QQT",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "X?dixIqM$TW/%Wri2.9e",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "#:%mQYth[c]=tJ5Ijd8k",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": ")7e~/AH?@xuJs3L@QIdj",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "Ax7E}]0xNeX/n/L,z{((",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "|1XqhlXoImmB9~YdQK-M",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "w.-_jiq1N;q;h|Q2*h#i",
      "name": "Gem shops"
    },
    {
      "id": "PY$-/Y[H7T`sc0OkqZA8",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "IE)uJT*q4ECH,dQO$-GH",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "tV7iNF;V]+f)LYH/zH1t",
      "name": "Map/Wave/State"
    },
    {
      "id": "L,2csvbYxx#YnE4Vb0Tz",
      "name": "Gem"
    },
    {
      "id": "s%xHUM7pMpn4Y:X=4ALE",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "3LhmxQkU!J)2fFQ~:;c3",
      "name": "Map/Player/Moving"
    },
    {
      "id": "!k?pFRTW4lt6N*Ni/hlx",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "Z^PoEQy5^B:6XfLi:0?o",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": ":lI-y`#!k0V2Fe[]!x2$",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "i-?1^H~V%5z7aa4:)XL/",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "^drL)D)5AORMh72I@A~b",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "9JTlR)jSIP0jRQ[U02co",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "oPTUNs])Ac3/IWBjP1iO",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "8em/0dUF-%CS!jC2-rkR",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "I-8++ix8unFi|-[el4Rz",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "VCYyvnQ{crMq,~Z+9Nvy",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "/C36n^O1Sx4M|;rRndT!",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "wZAgMXWBX{(eL8aS/m)O",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "5A@]4?QbCm22SFI4E|)d",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "[)#/:/8Yk!OwX.g.c6F7",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "@?8-$=L%pv:Zw_z0{B6Y",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "tRkO7]ArZY^IutusN+tR",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "0|G%v,Bovb5E2+@d=(l/",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "1`{*I5#F`sEU!j9g)HOK",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "Jsv;QQt@kU^e?Z`J_HG|",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "N-kKoM9Tu@~F2@B6=(Q{",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "x7{hA?0ci::tmXQP`D%#",
      "name": "@Map/Progress"
    },
    {
      "id": "sZEi;,eI-)F,ACGmy[n+",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "nsyUbk2VlK;,55FbyPUT",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "Iz8;T9V~wj:*^iAh3Fq:",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "9QrXXtkg6j_PNLd@,?}u",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "*L!.7f1:pc5fCBi,y6jo",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "8A^3Finv[wsRT]S|97js",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "G*BttQ3ZCF-@$__H0ubm",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "QVNa3M#O-9J)U.clU02J",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "Q/41`*{`CfWJVx~Hf[~S",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "|IgWuE)b.#sGfspa)8Bv",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "(e,jL1JBjT*+%sZ{jgS]",
      "name": "@Skill/Variable/10"
    }
  ]
}