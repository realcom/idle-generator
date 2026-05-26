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
              "id": "~INPd7j+sy4d3.3OA%Ju",
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
                      "NAME": "unitMethod:HasDuplicateInventoryItem",
                      "THIS": true
                    },
                    "id": "/ykf%X){]Xchz=S5s$o.",
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
    "name": "Buff_Highlander_Update",
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
      "id": "1AARM^-k-HxeOYAA2PK`",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "Uq(73l5Pj0NbDBwKwQ#f",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "ao${c`~%/uFTR:t8M7X$",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "G!c#eNpm4+wcl6zJxsWd",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": ".0yt0YjcWm$jo|Kavirz",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "i`ok5NuuBU$T+h.B8~+(",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "RJX`he6gJAFfF5MEhCC%",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "GrJM/|KP+x1)B.}U`;if",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "j-:V6bc6d)J3VSx_AZ;Q",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "!4y)7xTAZ++b10jL7GE2",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "z0OjtT+H2=CUdjry.s9Y",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "{35x/$O)%_gEN7skoDg8",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": ";;V,{%a)!14DMBmmeKf8",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "I=^9N4m7p]A#MT=(7Gr)",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "$r:bW+j4OBN0b3cMFnzF",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "p{1j:^R8X;NrW*kRmun)",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "big6alhA!ijbH.(qGle!",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "u6h{ytd{JNy6#-F#2[`6",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "-NmVxix,Y3OMZSyg$10Y",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "=+g%tz1MU;ashaC9e{_S",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": "QVy:zpP#wJZNi#,C:tzw",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "97apush)_}Bg!.CBga-+",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "IlUwXWVFw}D[ShUD,KgK",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "xpMeo{bC)j?U1^p`oap=",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "Hl2,=7R=r@)o#PIYSzPF",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "9J:LZXB{93p[I53Yu}$/",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "c$U=Q]oDaq?d3E;qxFGE",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "(EMn!HNl1Rj/lfz-V9tZ",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "eX5XYs.mDk#O|/=y;]0h",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "EQ_%ckDXfXG9KW${O:]z",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "%G1?W4B([/zk%oVvwD7w",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": ";`yc=D#*(g-oup1;_7m{",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "W~GGk.d*##HYXp`8hfXV",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "P%hLt4/Qpw7^c4$#ylTa",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "|1,0T`C@qPA+x!Sc7hxx",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "Cfa,r#X54`F%kN7xh-:F",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "RQv41({+Y-2F`t5$-uQ^",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "k{Vk:@=}KMm+0?)4lQk]",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "_GOI`^~}sc=[Gd1|:ra*",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "9`*NX~BLl^Pn,-*+ihfh",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "yVSM~oudSvku2:7Rhd=L",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "I))#=K(*h]]Tb?SsB6qA",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "G*Cp.0rgG@E1tU*D+uH.",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "aoobB*F)1s3xz`)T@,o4",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "THlQ(K~3=8TMo{LsRfe?",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "G$S,O:l(?(v6Crh_A/dF",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "N;Z+X`Db:d5lP`3#+_ux",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": ".GcBdiV4Ncl~ud}_3ifW",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "b6~nRxg-5zV,vc,^jpza",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "[Kam28}d+PUjJ/(WVt66",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "+!kBs`AY*BklUG~yCMWJ",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": ":d4/mV9jgDQsvB0K^avF",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "dW]CZenhrWpUSNxlMZ=!",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "W_KdPy}P!)L7+`P]UgK[",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "Cz*:veP{tMMi0`/|@=1V",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "]]oDu^76dsW11p$@,go!",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "(,g2]iKb0+z]b5`#jq?p",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "C^~sf3lkIEkLZ!LmNf)*",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "N%_hgmfC)|)U)U*M.#Ro",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": "xQj?4zw%J?;-cTRE92AU",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "ucx!JYUAvs5;t_bsrR4O",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "l8rN_2sB,mkJon;xJ=VJ",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "a+i(@OY(NXl2Q-l7`hwM",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": "NXH]xL*Hb9GqRJ]T5~ZH",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "rdR7Bc2/,)mkwDdYkv3y",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "K/*LD4//.a?!tKY^p^gA",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "}QKq){L/ae*[VVOyb9t(",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "JJv;{#[oTu7`#^HM6)JD",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "kBSGKj_zilU;$_/%@_zd",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "HH5AmAdN)tX=EP?k2!Nm",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "X?]b;Ec[w)@%9JPmF9kC",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "r](#IG5jCmp(|MEUxJ[=",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "1dVPCBo:bAkp}Puy2zc8",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "sm0nSIi;03t@=!U[u3a#",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "Hy3|jO#uj[luN^-i2iH!",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "$%U$vi=GeYFvzFnJ,*(b",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "tlqtO5}iJCK0.4(2iZo%",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": ")nn!Ko,iAHcZ1rfH^k,o",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "X(xz9:giP(`q+S:KUt$*",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "L-OdZNH${)O@[ML|Wn2w",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "xLPyH48h9$A-vFp|%h1=",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "$wfr4X[f%ZHENdT6)H0C",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "z(4%bGIQJ|AIgyBtc.uI",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "g+I),hO?#7VYv~k(|Y{3",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    }
  ]
}