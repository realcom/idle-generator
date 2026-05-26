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
              "id": "G3OifA.218*J6tP{B]{/",
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
                "OP": "GTE"
              },
              "id": "28Bh![hl~P,k7[M}!aQk",
              "inputs": {
                "A": {
                  "block": {
                    "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                    "fields": {
                      "NAME": "unitMethod:GetGoldCount",
                      "THIS": true
                    },
                    "id": "+-@cBJ@LlP)%FtkBx9^i",
                    "type": "function_call_return"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "NUM": 30
                    },
                    "id": "i:6dKot3(_RKQf$?ZK~E",
                    "type": "math_number"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": -3025,
        "y": -395
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Buff_RichMakeRich_Update",
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
      "id": "gM|J3=,iRA)^hpA(.rWy",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "l.N$I)qj8b:~Opnxc-B]",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "BfyhjFWbT-qtVi@4q(HL",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "y)7.%l!NET3J^z,RL54=",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "X$T|grMmkk+*7hSrfl/j",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "T#o6bJSG{d.TKM#1L`M]",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "Z@6hfGXG.l|fE5^}=Xv]",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "9y3qJ89;;YYvT9X+tOI@",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "EFv2aEQ4pFc%z{H/vp-o",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "1[-2#vL%H:/wK(gzK:7;",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "]2c{9FQhr}k1D]z_4+u|",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "v]0[?4hLl`v1QN[okK`c",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "b7?L-*/D(6;?Xd]=ZA6y",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "a3gc4GRuOuJogI!lPQfv",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "uChZgV6xWDgI/vWvotzw",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "(+{y!z9+1j}9Y_pKaeLN",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "R@AJOAe0L`kzfWMCS)^H",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "?`gg3chakMpD:swK+|,H",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "UNd+@nzKh%?#Z8^9U:A(",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "Jx5P,+t5?IWfn@r5dWV*",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": ".$Rbf%;#yED;vY(JleTU",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "a/(SKHI=4@/E%H4=,Br~",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "si,0/4H+F?EY41Qn0L0U",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "E4x#eU)L{s%34k-#(fl@",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "=9=:1}QB9]m$-kT5;haS",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "x4#b-.@,2e8^yG!GOB;w",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "}Gkc{i14dEi5%fZ;dCgX",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "bBp[Ky=}8Si*IeD,~HZw",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "/~~Jtm:*nJ}*,5Re,V3[",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "e94M|[pS}l@=-@o^ah=h",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "QKhTB+=EXXrP+`zGmGF`",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "2:=:5|IL[Rn/wS%-82@@",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "f]5=/D%w9D,B^Cd_P2y_",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "UJfkoD;?Ic:A]jdvnVJr",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": ":sq17D0zTn]$3~~[c[Yl",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "4*6xeb).8J*|EA3$*U5j",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "_9wTJZ.F(za$W7-a5R[%",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "SiycoCB(m!`|5G!NmNJJ",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "k2l%JCjIa-G^Vx7gNH`s",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "euz])bZBh9Ze~IKFS~C_",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "U:kQuEpx+xs`QmRz)p9U",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "piZ:e+~yGJ7!?uH2]S.D",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "Y/7_Ire*K$]ekZbx`.Y9",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "0_}Up3?k012+Kd3{q}#r",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "3/;v}U6kKTNu8A~1X6^p",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "uarr#/rs!teGxlL!OPrt",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "}sTfQ4e3$:.LexD4yO?+",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": "IgZFAp#LTZG!8_)V)$^w",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": ",YN/za5;z;W.[`P588)C",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "lT`+=}zJ,-tApbR#RTKb",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "@MrP`oB|EV9`3^iYjnLO",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "|UWNtz.`2BtfWBV@hmau",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "901R,}}b]o}3:Ty$qWvm",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "f].P`)A`UeQu^3.hJLk0",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "NjrcaGfLk)mNM4nCFA4Y",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "g{gqQ`a6/w/N8L:nNtq|",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "MKUzF7U/Wx)%`c{]KAV9",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "P9t5|:wXS^@dWgfG:x}y",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "v6j+L)*^!PpF5a.N@m+0",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": "{CvWEgd%X6^{2t;PRarG",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "q?UzU%g0F]+==85$(c|F",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "5m?7+.NsBdX+pQDQYWB.",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "xj~RfKGY:R)LJ[fkc1nB",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": ".yy$%~otvI3h`m]u}JU]",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "J|VTZ4y4:jW.4yLx706r",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "ondUNd0l4Jik)Y2TPIrE",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "ImUE(.,w6Z^J+8ta4uik",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "fj|42vd]kRNX5({bBtb(",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "c2(12:Q9H}6).T}rc5]2",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "Zx.a/a.L2SF4m%s*@4Pz",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "S0JRP?9HYlj:,k$qPQpu",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "?mcM$o0:lP@_H#67~r(P",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "TdrNMdxI_HTc0,p_s?z(",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "%s;jZpSSdKA{,T]MGlJl",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "l7*Wb8nqMCa[in5#C8/@",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "Lc+v,PiNJq*MpOc@s~|=",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "$3P:u5yg#!9MWVT:?Sse",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "E=i%(I2.lzsh6tcBhZ?}",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "9/[iX5e^/N0dau13m^%u",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "4#}1WS^x8%ofdbvLHoDC",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "~+-SCT9.,JxJ:qG50-z-",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "g2)oA{Z)HT0H73JW$)[y",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "$KVRQ1MLtxuo=UE|1DAz",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "Ao8@{^yJTF6FltOnaP,d",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "O$mACwx6dkBZjN`]1.7C",
      "name": "@Map/Variable01"
    },
    {
      "id": "k6~p]s;^8e-Ak`Yr*!0j",
      "name": "@Map/Variable02"
    },
    {
      "id": "hiw[.8[:{*(H%~fV}K8Z",
      "name": "@Map/Variable03"
    },
    {
      "id": "+391/~rkKr-([;DK7WhV",
      "name": "@Map/Variable04"
    },
    {
      "id": "9[b6o8HBOUJm{txKTc$R",
      "name": "@Map/Variable05"
    },
    {
      "id": "2*y%[z*n=Z_5UZC_Bd]$",
      "name": "@Map/Encounter/Unit1ID"
    },
    {
      "id": "@gm8d!($XB/**g;1;u)?",
      "name": "@Map/Encounter/Unit2ID"
    },
    {
      "id": "GgnNYSfGvR74WZ3AUc}x",
      "name": "@Map/Encounter/Unit3ID"
    },
    {
      "id": "IzrQxa;vW$J26.5E{4r)",
      "name": "@Map/Encounter/Unit4ID"
    },
    {
      "id": "z6[7}:5LYd]^Y@7*ff-m",
      "name": "@Map/Encounter/Unit5ID"
    },
    {
      "id": "61/?O}*v|p:8]2UQ/qL0",
      "name": "@Map/Encounter/Unit1Percent"
    },
    {
      "id": "4TVp+a3I|5)O8%a!}%Hf",
      "name": "@Map/Encounter/Unit2Percent"
    },
    {
      "id": "yInH!;/KAAZ}QBU)`UP@",
      "name": "@Map/Encounter/Unit3Percent"
    },
    {
      "id": "2z^nFI;zgQNpS/3uJi[a",
      "name": "@Map/Encounter/Unit4Percent"
    },
    {
      "id": "@,I)K19O1d+01h,L.1F4",
      "name": "@Map/Encounter/Unit5Percent"
    },
    {
      "id": "U(gc[ao:2XUV}f~RI~3v",
      "name": "Map/WaveStartTick"
    },
    {
      "id": "I~_~$!crQINPh,62}F^%",
      "name": "Gem"
    },
    {
      "id": "zzB1DWq9K~SJmX8*(##~",
      "name": "@Unit/Variable01"
    },
    {
      "id": "j4?C/FvXid+zkz%I93mb",
      "name": "@Unit/Variable02"
    },
    {
      "id": "5NBc?zKQ64putMZSMzpE",
      "name": "@Unit/Variable03"
    },
    {
      "id": "}:G21XXA49E^nvwX$@fn",
      "name": "@Unit/Variable04"
    },
    {
      "id": "0W`V1`@MtplBBiOX2:rU",
      "name": "@Unit/Variable05"
    },
    {
      "id": "JF1WWFdVRW^a2:l0?rRQ",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "%![zbPS*sYle)4ti]o%!",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "ggn~77!FuJZ,Y|[{Z|$;",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "b%}kvnJ7Ka+F=l3~:7:(",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "jmQR4C=h+a=}Ef03Fh#}",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "sNp6`^+6OMW,f:jT?I3_",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "/v0EE`g$vu1{,*fpy67H",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "E.0Z*cQjmAU{2*Q{N;G7",
      "name": "Map/Wave"
    },
    {
      "id": "CdkapGdnrw$Dt)l#@H+I",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "bZp$/R_!s`]-g`}D{rYG",
      "name": "Map/Wave/Step"
    },
    {
      "id": "GbVf)0UOGS]n;=U{/w.H",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "E1z(9SRfa1/4sTuG,LH(",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "0W}v^g2|~-oIh88a$|L*",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "V8O#rW8Z);@xq#3hmvr#",
      "name": "Map/Wave/State"
    },
    {
      "id": "]+wx`vAa$c_bz|seO-~9",
      "name": "Map/Player/Moving"
    },
    {
      "id": "oYb2w{^H.I]Rqhl+%cS7",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "^_;#;#SXAa!)_!)5!.]}",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "[CARSHvx#UOPaC4.lj6)",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "/|:-@(W~Y^2q8W9c#@cM",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "gh8Q%nM1-u{$+xN5T5g}",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "T_Lx@?,8iR8OU`yf8+Cu",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "yNrv|u?CG6[%~C;Xn21H",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": ")VK1jwqL(kdeyTdIresC",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "7]cx:`{=ZPpDO8N#L|3#",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "~=FVwLBr]NKaI2YGY_y@",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "y7bJ{)1j+-Q]8;w:5=)u",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "J,WyQjA83Ni)%EmXYj=a",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "sn3Nu,ht.4.c_7=m]H4-",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "6._m=wGqMwoIAib#zb,N",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "(uXa/kPUPIbkTQF]BJuc",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": ";p*yS7O*G)]Wq4#sMC?E",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "(k;(z*W_UU}76q*hdy0p",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "KXXO3:1y|p9.4muKa{NO",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "j2ZTSg9U_YZs(]XA|3@{",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "V{n_V,~iRp:]]$NUk#{u",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "4j6w~.^{c73zYMG~3I:6",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "y~uqIKT@Z/DsX~U%aZTX",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "q7A,b?lh6pR4Vl@,q;17",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "1OUGxgyZ#v=-m+V%DGaD",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "lX_W~^#v|QdglWC0QK~1",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": ")d@U^9Wc$b6EIODjnfIi",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "2sf,=*{:.3PmD:IM~yK`",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "Qv*+B;I*#4l`m_$|^L4w",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "[2am0pvvkSz-l(.p$rCX",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "w8%%|/)_u^(W8=@Hwh:(",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "jw[[FiNV;lmHfD@s_]}B",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "uAy=F7gL`gPaIx|n)|qO",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "_Gm)cZM;U?aRwIcQYU}0",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "qm@{mj]z3g-!]~LHUSEe",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "Jeq#y^Vm+@Q!s2l1)oI_",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "F-XkP)9P*p+:2RZo)Ope",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "|RAHJ.s02%[gM}7J{nL/",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "tmRN.+9C$~by.xhT;EU[",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "8R3W}H?C#mR2/1%?.`_]",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "yD]zks#``USWniez_i$v",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "]zQCc#Z5:K4-j5]5{tzw",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "#/Jux?ql`(1}7jj(Ee(v",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "Rik?4~i)YX)!Mz|]qHf7",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "XRg|xiGDklu0m@JO%icp",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "ObFhg@^z;VnYX$Q~3;Vc",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "s|m(LvBnDHjOn(;;e5!:",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "0*kXV$,(aWgerBv`.$7E",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "Z7F#jIc;?6P.4#M{Yt|$",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "JA(|zA$_Vzb;UGwN[]78",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "^xQ;Nr1~x=t2?@QOY#Bp",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "woi(2U+3r)5N4D7h$O~i",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "=7ImCfp5USDYZ,auvT$*",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "3(=vjSdgUd[`r3T[Y~6^",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "SHFX[*])8]vLyS9LtY=R",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "4x)qfHWxlZ,rTGfqr2S4",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "ApYT`UD!9yn+%)WndloO",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "TtGxsrC`2,C_1;u^iK61",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "(Kt*2YsP~GS!0Lyy%0TH",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "AykV_x*-HomC:m%/nbL?",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "^i{Ls_k9yD;6Kx.TWJCK",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "@_CpG`X:{8LjN{Yg)=bT",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "4S2l,?W][[kx99AN+q[u",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": ")*/%Z8zjF/XX{L1L|B_U",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "W=Zl7]0{}}[,wW+!y]ti",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "N.KbFpQ(GdBgc+QrTt,]",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "AciJ(03_|F7;m%EbB8k1",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "/+)m?L$*|HJIG)N)S;[m",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "P3C^8X]Y$ZC$|E)H|TB6",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "IStJ:pU4lK.pnkhh1tfV",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "V`7m[^,XtfKKEQ8,/*8F",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "ebz31)2w$:WwZE,]KEiq",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "SYWeT1,}=T`pDfCsi4Bd",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "Pv}zad4msKPzHvK*!-du",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "|xq4Bzh~=jVekwuzY3s=",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "fs38Jjr8OxPXfFS9R8|7",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "?QYAv8lIUQB.W|tEk~,F",
      "name": "@Map/Progress"
    },
    {
      "id": "uF|;3rY)_#B^n$|?u`J^",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "0[[p%D|,Ri,gsEV/?h#T",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "!`@%N^;EE{=ow}cHpt0+",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "AEAfLUODfqe^HKGVr|lc",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "x3l}xz9;51CP2jZR[mdc",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "Sxk30s=My=mG$f}2)f%o",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "qrc8?7EPxr]Z^@Bs)-b}",
      "name": "@Skill/Variable/10"
    }
  ]
}