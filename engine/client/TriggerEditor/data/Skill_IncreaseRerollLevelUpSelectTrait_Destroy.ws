{
  "blocks": {
    "blocks": [
      {
        "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Count (필수)&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
        "fields": {
          "NAME": "unitMethod:IncreaseRerollLevelUpSelectTrait",
          "THIS": true
        },
        "id": "8++)e~;^L3D#X(f:SKVs",
        "inputs": {
          "ARG0": {
            "block": {
              "fields": {
                "OP": "MULTIPLY"
              },
              "id": "BYDT`!,(Mij$AHz6zBmx",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "THIS": true,
                      "VAR": "skillVariable:Level"
                    },
                    "id": "|9#2UH4cJBnAp(M8Bx_B",
                    "type": "variables_get_reserved"
                  },
                  "shadow": {
                    "fields": {
                      "NUM": 1
                    },
                    "id": "G:u-C5qw+3CGTvaIJHu?",
                    "type": "math_number"
                  }
                },
                "B": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "XFi)UIL;.sL%S#R:!V5}"
                      }
                    },
                    "id": "Bv[GTznsYMV(^vqpg~,p",
                    "type": "variables_get"
                  },
                  "shadow": {
                    "fields": {
                      "NUM": 1
                    },
                    "id": "}%g*:tAiWO;wvPd5NTrU",
                    "type": "math_number"
                  }
                }
              },
              "type": "math_arithmetic"
            }
          }
        },
        "type": "function_call",
        "x": -2715,
        "y": -595
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Skill_IncreaseRerollLevelUpSelectTrait_Destroy",
    "period": "15",
    "triggerType": "5"
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
      "id": "XFi)UIL;.sL%S#R:!V5}",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "m~yrZl3I0eV.)o`+-b]s",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "4u7al+/BL2#YQo#Q^C44",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "v-3nz/FQBJte/q`R=aR^",
      "name": "Gem shops"
    },
    {
      "id": "up9iT?w?yu4yGTv`iFKX",
      "name": "@Unit/Variable01"
    },
    {
      "id": "X!k4s0gHgdkd2AmP?KsP",
      "name": "@Unit/Variable02"
    },
    {
      "id": "jJ]x(}}#MBXa)60;;hN9",
      "name": "@Unit/Variable03"
    },
    {
      "id": "OtsDcU-5qk#a]rDZdue)",
      "name": "@Unit/Variable04"
    },
    {
      "id": "4#~#5o5Df?.0oX6POfcr",
      "name": "@Unit/Variable05"
    },
    {
      "id": "*I?C*9B:r/FyKWM!kvIO",
      "name": "@Map/Variable01"
    },
    {
      "id": "(AD%|opxC*C4vHv1}uf5",
      "name": "@Map/Variable02"
    },
    {
      "id": "lH6a1m+28rQN)pI5DL%@",
      "name": "@Map/Variable03"
    },
    {
      "id": "1B!Imc0OtFB3.s$A.Wjm",
      "name": "@Map/Variable04"
    },
    {
      "id": "lgZ9*%!|-88$TKLB%7,(",
      "name": "@Map/Variable05"
    },
    {
      "id": ":$P[pU+cTXLFI!kE5o)r",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "kpT7wt2+LLwIr#iu~/|[",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "YQhc*a$UUC%bYxa(.Jx9",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "M;a+~,vVgn5vEdK|uWuJ",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "EJQm+}rkw04=H~8H~)/_",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "WV,f/lB.@,7kV6n,z(]O",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "B*Dbm`*qf4vmI5n8tFm?",
      "name": "Map/Wave"
    },
    {
      "id": "X!}[2oD%j(CU1T19{hj0",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "^,DlLwK=Jq99c%8daVi?",
      "name": "Map/Wave/Step"
    },
    {
      "id": "9C*8UbwDIG_`F9!zqvl-",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "p7r,fXYpY2ihMZCUJpkM",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "TArMT6bly,u$?1i*:wEe",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "G^@;R_{V#vAk.Z}4pr5b",
      "name": "Map/Wave/State"
    },
    {
      "id": "pG{/y8^aHVzoq!~)z.Do",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "0,dYmu;MZQWJ8QjWUR%5",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "S_.mPqvwp8`2i$G}^(Wz",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "JGrYTGjjDbf+P9-?;/qa",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "n=)0;af#$?SK2Ku^zCbu",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "1*V)aAR7ZRqf7?LxF_]K",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "bdf+ja4z$+/bG/6}XPG3",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "T+}erY^h,~W:}},dCY2}",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": ")_0o}no(rwKqGmb)TF*W",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "4C?*/^7oEWf]-6mG?|DS",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "$ZgR6;(MKMh.AXcjQ--/",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "A+Or8a,m[lYYnKz`3:$$",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "K2#UN5):8u|I-QZR/hTH",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "azO1JS,]iJasi7BBJ61k",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "7G7YxjwWbic?-l/advz_",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "W-(.ZS64Jm6.Dg]^,:ik",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "1}kfKU{jCe}qzqiz#wI9",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "cFnL+jj$dIn~QE3]/g8R",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "x!Pf*ftfKB.@lz1pLO%h",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "~8D(qD6U=2oy(W=u=b?T",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "G=bd5N,*[(be5An?.y-z",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": ",moaS-_crSZ~6u=DkG2j",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "Ja0I0u{;)Ubbw(hvcj8(",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "zW.[D%{bkxratAx)L2`E",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "C5VDx*?)usv-+SK{,wTW",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "X)$eG*$qFQX+/E5tKK=x",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": ",bOK(tSsHn3geH:1{cTk",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "=AEk#OQ{|5j+|T+b:3UJ",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "x]@3qojmlr*}0-!eiBug",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "!ilW6WR#e+.PYbar!D@W",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "6!qcI0H+8j;1UrV^6=xo",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "R/*tUNkK[4.L2cYvt/Vr",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "]usC~3;5emfX+49GEiK.",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "YmNlB}g,%Cb1b]?P/LoQ",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "RTg;H2Y{$hk~XBbI8UaP",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "@zLDxL4Ctfn[%K*qgnqr",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "6Wg6We{~{,_:RtrYc%@0",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "1bdj4tm.cbIkX=vp@_d#",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "cP2GXbvk*lkoFg:f~P3D",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "`xd.]I^m]C0eE`%r`FyI",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "6p~GA4PI$p!qy`bpO/_e",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "5!oeEoJrIcghBn`_+jR1",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": ":p}ZA;Gd]1]BeM(hax@0",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "Y7CFK{eq?KzECp@H:aoy",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": ".?Sh?5vYi_=l.4~D{D8~",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "icGaohrPLl,*VPJz9jL*",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "xm3xN[a1Lq*Jz~-Aazg3",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "Ju.eRSzC`:6Fj,7h`O7.",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "j2`|*Lu*%NSJJEE4+m[s",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "x|{_}4n9_dseHKZb?rkt",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "iMXw*oG9@NP{3Ch,B2}M",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "?-Rg1`7gx5+?S(IcT4S-",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "Nk7;u:3T(asQgQ2b.,hu",
      "name": "Gem"
    },
    {
      "id": "J~L8`50+06T{jw~8({Fl",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "?|d)d`6Yzb^GE;@($7;b",
      "name": "Map/Player/Moving"
    },
    {
      "id": "wD9IjlpZ%q6}Yjy?2a2n",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "f%b#WVu$=-/Gf}(q!YMH",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "+)99uopNLK-Te%3M-BlB",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "}pK3KCowgIpZR}]f81S~",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "v3839k(y,|*+p4;e^|~j",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": ";WRig7@;z%Q130,BuP92",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "}mOM?~::XnMYq@H!jfHE",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "*[^@0+W^,/!x[[MC#eG1",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "D,[hs?j7@{e$@xt}{:4$",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "W#Yd!C#T43bx1hCh7kUz",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "`YtRaVJ{kD`*CUC$Q#ni",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "g6Wj^c@-5z#TUDw3|vm`",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "^?zMS?Q6Xbb,,7E[/%6@",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "9k+q@s[zp[-^Xbx%gnKl",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "aee(yR_#mP@0Ssfb!M7e",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "GL(CyZYc~XUPzY?9e!XM",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "X)F|1twk?,;#,ZHZ*=p,",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "DkNCwHv,l0H4^c6Ut*Zv",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "/.awN1wnYp{218lx;vm;",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "WLEBkSix~ACDYL7C:K~@",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "aD7o.+}k3,m?FWf]en6@",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "5CSz?^DGk@im^*P]~?m~",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "jloIfaK]bp~TG.ob7CEH",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "L8!b.ZtcP(q)ld{l+h}~",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "QjgP+]WZ2FU}jQ)V;q2z",
      "name": "@Map/Progress"
    },
    {
      "id": "nS(mu,:CEna|T!Yp2S)U",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "V^^%OWx,@$HIvcqm:_MO",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "$r(oC(y_tAozk!^]OiHT",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "LB+)d+C$_nX/R:[D%K[%",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "uDg(Q8{@dz6Ud%sf)LWk",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "#rbBA+w4z4y5H-eaty+5",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "ShUt(Jo~[=OyCc_Jq)^a",
      "name": "@Skill/Variable/10"
    }
  ]
}