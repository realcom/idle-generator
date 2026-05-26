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
                "OP": "LTE"
              },
              "id": "28Bh![hl~P,k7[M}!aQk",
              "inputs": {
                "A": {
                  "block": {
                    "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                    "fields": {
                      "NAME": "unitMethod:GetCurrentHpPercent",
                      "THIS": true
                    },
                    "id": "+-@cBJ@LlP)%FtkBx9^i",
                    "type": "function_call_return"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "NUM": 50
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
    "name": "Buff_Berserker_Update",
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
      "id": "-Jv^*MzPklP{w$1pDJ[J",
      "name": "Gem"
    },
    {
      "id": "NSWeAro6xeE_`$hdOp$C",
      "name": "@Unit/Variable01"
    },
    {
      "id": "G?!CTkk)+1Ay]rPQtZq+",
      "name": "@Unit/Variable02"
    },
    {
      "id": "^{YGaTYK4${1|8X,]hnP",
      "name": "@Unit/Variable03"
    },
    {
      "id": "`=r:;6N~raI1Xg}AB;oY",
      "name": "@Unit/Variable04"
    },
    {
      "id": "Agic|*iHDC}6u#fy)rMk",
      "name": "@Unit/Variable05"
    },
    {
      "id": "oA=8Y(pBrtd}`ONW:!rB",
      "name": "@Map/Variable01"
    },
    {
      "id": "Zxq~Tr+(EdD%b$);[dVU",
      "name": "@Map/Variable02"
    },
    {
      "id": "RV-T3yE_f*t{NtWR$hx_",
      "name": "@Map/Variable03"
    },
    {
      "id": "I*Y.*h_3e@!0bm7$*CF1",
      "name": "@Map/Variable04"
    },
    {
      "id": "NACnzsX98ayGK#DdGuy:",
      "name": "@Map/Variable05"
    },
    {
      "id": "y(1,zHO@@UhMHsq(rssC",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "Fb*e6Et-4{f.byXDehVb",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "7#RZPOlIy)-_iWT/HEW=",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "F`dETxv9sQTlL$S^iC)|",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "#i29?hWJ5[Z!N%%lmK!r",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "$7Wa%J|LQh;-GI-f*[KQ",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "{4.9IsOorKn3NSA!ZD!8",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "F-%fM(JIHgt^45p6UW-B",
      "name": "Map/Wave"
    },
    {
      "id": "yi=2%LT7Yx%?4NsmPS9i",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "-vm*%n}#8o19PCJS7U4Q",
      "name": "Map/Wave/Step"
    },
    {
      "id": "N(^9wJatdeG9C9zd68cl",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "i]8*w,HFIS]AgC#?3[r]",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "t@M#z)n]R_ih;]JTFl[x",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "f;`tXWPcIaEcs[nBE]cr",
      "name": "Map/Wave/State"
    },
    {
      "id": ";%@Lg=eD+Za#mb+G0gxR",
      "name": "Map/Player/Moving"
    },
    {
      "id": "-)Q3D?@?*n=sSCIX(%0L",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "h^Rh6r2L$R?7}ictEt/B",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "0adb~2%hY|3K1tx-lCrm",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "8jKRi=lbJ#9p-_EK^$E5",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "F#h+|nPa$T`hI*9NJ5e@",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "}y.|mfI`.N;H0sjE{w0r",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "m)w{+/}9h5=}_:2t$L.|",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "K)z-aWa{l^rrYjO}4Z]i",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "9BJ,@_{xtM6{5(N-757:",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "XINP;QlYj7qe;~|w|hcV",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "*{,Sp]CKOLbq|Rn%C|MM",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": ";:=y8K2v,H?[p}gt)Go[",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "LqVVj_)Lbx1zS@D;?t%J",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "$}=EfG3g.?6sNc7c~!o)",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "j-%-pT9^G$~_S`J~sSnl",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": ":M!7XRfz{LA23jIFTir[",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "nzy6jL[:{dY.AB?w`]^;",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "].9n7zR1TfQs77i3nI5s",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "T8P$]4Ui^_AD:Z~rCJ5h",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "qy/9y.;QT4Ys8)Oe@IAM",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "k;$Er1@s9}jok/`P:b@(",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "#B1xOuM(6#1L}6*c!o{r",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "Es{*B/:UV?0i%+;fx/-}",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "Y00{WNW6p7`3N.5a.0Xs",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "{]cg{xQQH`!/|hVc$7._",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "AW5X.N{_7`JMeGmnoddc",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "37|.520j/9)42D0bhWE7",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "$laH)Ynl|+|,1^}T74LM",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "6ml5;UI{d;8MpIQB9d~|",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "+Ozv@,eQ}OgQ{.7LX2UM",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "$OZYbC7K^+e[EBc-ft^}",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "A7u|iEf)nY1=Q?ILY%z7",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "^p)[2EZ=[h|.TRPA-6iq",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "gv,n*3`hT4a4hNr5D$!^",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "iaxmqen|e[{uIw_ezg,d",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "diNNRyPl}@H#@,I]p88$",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "j9B%l{NX[t.Vli)c:jIM",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "Hp+|J3+VT[B9/jJR{]w=",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "q@@W-V64tcdwtn@BC!7T",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "VsziR;sda]UOHPGCdfn2",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "uN`$wvBXzq^R,SD+IoF7",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "1x(/?yVL9]L+ASD$!^ZR",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "V#5ACvq(KNOw~$=cUSG.",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": ";+/A|HVF?,[T{y}vR6[S",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "no,bm/eC@oZu-N5gYZFD",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "J]@KlF(L%6SY+oUZ-)O)",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "Fd#x?t]6.7KN)ZhTSJ^?",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "#-J44}|ctOu0vA3NfMs5",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "t|NX,FkRU^wCted;;rjh",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "Ub9]U*Y(B;MS6i7p56Sq",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "#[=LieS8x#QT76%JY5+c",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "@3AC}hdt`Dk]/;Qm5N_C",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "WMf.h{2{.0SbV-iK)Ua^",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "|Ait5gpzu5u{d~$gse+G",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "%hQT_*2(V;R%GaDyw00+",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "TA/c+hFYo{x:g{*V8KVq",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "WgVA@FK$Pl=u/]dTD*l1",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": ":%Vwi7~uoIls1)WE#1q@",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "M~:pTTT0zeuXBhuM|:tk",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "z`QZIp;n_JZ,`?:p#R2,",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "S}-h~R00MT`,{2y=ypL1",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "zIgcIY9c-DkjzX$vP]hS",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": ":Sg!HsAHO^/3!qrBJtC|",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "$WP/dXQ#udl,G;@Su|em",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "QiG:U8@P9kDfOI1:`P3U",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "4y3e4jxS;xO.2)6_p28V",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "Mn9|*l4k$RO$Rt0+EN:m",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "C]^|F3F=^%P1wN!q?}L)",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "90;=xvQ|?[x@vQh4J/~I",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "@R~LE)oQX!]yQ++uEV:K",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "TdAd#b1hkAXD}|E_yVci",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "eZCYDSt=*=.8NV[A`nLe",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "d}OlQJU{/x{2BmDK%_Uw",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "sxy{}JX;4!1]`%5~9ABG",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "/6UZpyLBa0m~btqDjwVQ",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "O~WfcK-5mz:B4t)ob:bT",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "vHG(%JI1B!50dc4}_XKi",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "lk:ZgOW(kMI)@y:r@)Mx",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "g}mx)(3tq_)Mbj_:}7Qs",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "8`]IMQb3OCuV7eUCHu#O",
      "name": "@Map/Progress"
    },
    {
      "id": "Gf=)[):Rlx5tCo3McYG^",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "B|(wO{@R_PHCsbG0s9kQ",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "u?F{8f0WfdxO?9=A7iA.",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "K(2!B@vFwf-q`,{tCZ:p",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "w3~m~#e7=HM[8[/@LS^l",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "$]D+70MMJgvg#^@%ML)[",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "[d*H0$OZiVV9/P-KUn]u",
      "name": "@Skill/Variable/10"
    }
  ]
}