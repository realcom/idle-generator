{
  "blocks": {
    "blocks": [
      {
        "id": ";1WgCkhCh#tPd(x4!M.=",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"5\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;},{&quot;comment&quot;:&quot;PositionX (default = unit X)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;PositionY (default = unit Y)&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;DirectionX (default = unit X)&quot;,&quot;name&quot;:&quot;DirectionX&quot;},{&quot;comment&quot;:&quot;DirectionY (default = unit Y)&quot;,&quot;name&quot;:&quot;DirectionY&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:UseSkill",
                "THIS": true
              },
              "id": "C#5oVnZFG{^7=.R!OTpw",
              "inputs": {
                "ARG0": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller__skill",
                      "VAR": {
                        "id": "iwFxvxo4BXrta*(yb=80"
                      }
                    },
                    "id": "L/2OcnoPYLloaBB/hEx!",
                    "type": "variables_get"
                  }
                },
                "ARG1": {
                  "block": {
                    "fields": {
                      "THIS": true,
                      "VAR": "skillVariable:PositionX"
                    },
                    "id": "fECY1~2Bb(+4PEG2ci%l",
                    "type": "variables_get_reserved"
                  }
                },
                "ARG2": {
                  "block": {
                    "fields": {
                      "THIS": true,
                      "VAR": "skillVariable:PositionY"
                    },
                    "id": "W`Yy(QhIj]KN5.aYQQzI",
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
                "OP": "GTE"
              },
              "id": "Y)w=]G}c_!ZGq,iYjyIj",
              "inputs": {
                "A": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller__unit",
                      "VAR": {
                        "id": "WmwPb(!fNp?1Z{1%9.%e"
                      }
                    },
                    "id": "j.)UdTzd]d?pE**SSlWZ",
                    "type": "variables_get"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "NUM": 1
                    },
                    "id": "/P8VO1bL%qLwt**SX^ur",
                    "type": "math_number"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": -575,
        "y": -265
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Skill_Blast_Destroy",
    "period": "0",
    "triggerType": "5"
  },
  "scroll": {},
  "variables": [
    {
      "id": "!-]nt6$a6is0}O~YVgwX",
      "name": "Map/IsInitVariables"
    },
    {
      "id": ",0=:fzJ~|}Xhf_X}igj6",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "zvkF!pg-oC2bYAj5oqp1",
      "name": "Unit/Time01"
    },
    {
      "id": "q8UUU9VV1.|A{KJd|?5,",
      "name": "Unit/Time02"
    },
    {
      "id": "ETp9/B[*KqSNj7(Fe5;z",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "VGejr)b|8Gfl(RLkW-nc",
      "name": "Unit/MonsterID02"
    },
    {
      "id": ":]#[c:CYLIyP+ajc=3;d",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "ebIHt-[!@`1:VG3Vwq.o",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "X[9[hdmByVHK:]h.HJvW",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "-f1/B=hZ|1Q%Aq6FbLZi",
      "name": "Unit/Tick"
    },
    {
      "id": "NqB3.8gqn@Q]ElPP(@HK",
      "name": "Unit/Rome"
    },
    {
      "id": "xF/F!?t$d3V5%jA}qMuc",
      "name": "@Unit/Delay"
    },
    {
      "id": "sMR%O[2lUqvCe@L`SLCi",
      "name": "@Unit/Range01"
    },
    {
      "id": "S0A2qo#CQ$W_~IG[mQ~@",
      "name": "@Unit/Range02"
    },
    {
      "id": "5Vj!l|+p#pcNxk(:+1le",
      "name": "@Unit/Range03"
    },
    {
      "id": "-x}b=FES(D,y?1ZWz]ny",
      "name": "@Unit/Range04"
    },
    {
      "id": "7!$8Y*oa],Epbh1sMddQ",
      "name": "@Unit/Range05"
    },
    {
      "id": "Cui|_[g294f}S_wZE+O}",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "-:g(h.=G41NNQ:.0Fzi7",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": "=*5eFDs4GQ)0mjl*Sz2`",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "Kv!;@P_XARINp[od)9oi",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": ")EOp3)yv==cSvZDbK?0I",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "FtR99l;Z*xM[Y|}(Dw9d",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "dpV;=|YIm7gplDG)vfN%",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": ":JrJqOQtm=/ES{M_{[J+",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "f{N22SDu=J%v:w:Ch2_)",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "+==O64wb_L#K:F#I!8BK",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "%UlWHbI#pJqf*v%A9#/P",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "-4reVm?F_/Ckrw~CSXR,",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "fS{D1HM`dH}rp(q0~OB,",
      "name": "@Map/MonsterID01"
    },
    {
      "id": "%9%b9Gz?oL#mYP(03L-l",
      "name": "@Map/MonsterID02"
    },
    {
      "id": "o,Udd/C9EGfvKJ~c(0Kr",
      "name": "@Map/MonsterID03"
    },
    {
      "id": "o-m)P~7yx*zd9z-hHQ%V",
      "name": "@Map/MonsterID04"
    },
    {
      "id": "(/ywO{h^a]HU3l~o=V4f",
      "name": "@Map/MonsterID05"
    },
    {
      "id": "/|#`W@-G0CCR[Wx5yY1=",
      "name": "@Map/MonsterID06"
    },
    {
      "id": "6AXrbuzE:32`So31}hRt",
      "name": "@Map/MonsterID07"
    },
    {
      "id": "DjuFn}JBx!SBtVckhT1D",
      "name": "@Map/MonsterID08"
    },
    {
      "id": "-:8*1c+#[?^W^zFdqDHa",
      "name": "@Map/MonsterID09"
    },
    {
      "id": "gKKOoQyVX)AiS/P`x7c!",
      "name": "@Map/MonsterID10"
    },
    {
      "id": "rD/VC/e%ZC}xD*N,k}Q;",
      "name": "@Map/MonsterID11"
    },
    {
      "id": "_0@Y/q2/+pE}hzz/v^~K",
      "name": "@Map/MonsterID12"
    },
    {
      "id": "Am#AdYtUmR1wEUq3^cO1",
      "name": "@Map/MonsterID13"
    },
    {
      "id": "**bDih*AAEQZoycow*5W",
      "name": "@Map/MonsterID14"
    },
    {
      "id": ")d$_^y,r`;[eL0^v1|8o",
      "name": "@Map/MonsterID15"
    },
    {
      "id": "|*Q]2KY_TU)k^x1oI%x_",
      "name": "@Map/MonsterID16"
    },
    {
      "id": ";kD:KPHce=+O;}+,PE$8",
      "name": "@Map/MonsterID17"
    },
    {
      "id": "GD+ys3.Klg$J]T?-IWmD",
      "name": "@Map/MonsterID18"
    },
    {
      "id": "G9L^wWy.ye_wOEy/wnfI",
      "name": "@Map/MonsterID19"
    },
    {
      "id": "ehSE=Yheh]^@V=G-#fj0",
      "name": "@Map/MonsterID20"
    },
    {
      "id": "5nxl#YZTuol=Y2f-q_X|",
      "name": "@Map/MonsterID21"
    },
    {
      "id": "{{vKhyIU3Bb2On9Eu$)8",
      "name": "@Map/MonsterID22"
    },
    {
      "id": "I8;$;@Ec1F-Qb@_1%8R!",
      "name": "@Map/MonsterID23"
    },
    {
      "id": "7[aFNKmTOb%4vIx%j4b~",
      "name": "@Map/MonsterID24"
    },
    {
      "id": "-=88F2J,|V:8)5(IKGl|",
      "name": "@Map/MonsterID25"
    },
    {
      "id": "gWBGBZIG4xufBtb!mt@V",
      "name": "@Map/MonsterID26"
    },
    {
      "id": "mN[Zu-5/C:Bt:PW}D@ol",
      "name": "@Map/MonsterID27"
    },
    {
      "id": "NHHl0es{Y0jAWGAuc$lQ",
      "name": "@Map/MonsterID28"
    },
    {
      "id": "4C_m$;y#X$xW7yL)zb??",
      "name": "@Map/MonsterID29"
    },
    {
      "id": "re##*Z)xQ`n3lPN*J50R",
      "name": "@Map/MonsterID30"
    },
    {
      "id": "c]]IRdNsHj0atbXS%j:j",
      "name": "@Map/MonsterID31"
    },
    {
      "id": "9UrJ:/fb-*K3]?hL)*[(",
      "name": "@Map/MonsterID32"
    },
    {
      "id": "QusqPW.Q)z_y1w:(~7%k",
      "name": "@Map/MonsterID33"
    },
    {
      "id": "{V6056G!pPOx98ZH?K6f",
      "name": "@Map/MonsterID34"
    },
    {
      "id": "eUKd{|EuVqw#yWLs70xa",
      "name": "@Map/MonsterID35"
    },
    {
      "id": "U#xi8dpuPAjOWw3$onH!",
      "name": "@Map/MonsterID36"
    },
    {
      "id": "s|#guT+D@GPgcBL2znqq",
      "name": "@Map/MonsterID37"
    },
    {
      "id": "#UN3hM3TTEKaD/4-@7g[",
      "name": "@Map/MonsterID38"
    },
    {
      "id": "Y5|1JQ*z~^HI.MR,ugtJ",
      "name": "@Map/MonsterID39"
    },
    {
      "id": "qI`e41yP|.~OM4Lw}(RV",
      "name": "@Map/MonsterID40"
    },
    {
      "id": "YJB:uONFpm0aU:BpedSA",
      "name": "@Map/MonsterID41"
    },
    {
      "id": "zP?rX?80Jdb[y^8#P%c*",
      "name": "@Map/MonsterID42"
    },
    {
      "id": "0=Us+5.Uhq|Em*IB/EIm",
      "name": "@Map/MonsterID43"
    },
    {
      "id": "NmFx4_ZNEAY*7H59!)t$",
      "name": "@Map/MonsterID44"
    },
    {
      "id": "5g%Mrp_p7trfY{d(3k)0",
      "name": "@Map/MonsterID45"
    },
    {
      "id": "B0iEtQOcwsbeEjr_kdA{",
      "name": "@Map/MonsterID46"
    },
    {
      "id": "#34wVJ-/|KBw;|3^An-j",
      "name": "@Map/MonsterID47"
    },
    {
      "id": "@j2W$;{MX2i+].pS}Q?u",
      "name": "@Map/MonsterID48"
    },
    {
      "id": "cT`pPtt=yw0Gpyore=C(",
      "name": "@Map/MonsterID49"
    },
    {
      "id": "Xmj~FU-#-EhJlnQpZODl",
      "name": "@Map/MonsterID50"
    },
    {
      "id": ")~~`w(J!bNTVL|YBZgov",
      "name": "@Map/MonsterID51"
    },
    {
      "id": "PXjGn/794:-E/agDaGAQ",
      "name": "@Map/MonsterID52"
    },
    {
      "id": "a!@UeyI{)U`6ZvPv-BkD",
      "name": "@Map/MonsterID53"
    },
    {
      "id": ",).6KISO-B0`v|UyYE!9",
      "name": "@Map/MonsterID54"
    },
    {
      "id": "%6;1aa[#CdeqEIqeKs=+",
      "name": "@Map/MonsterID55"
    },
    {
      "id": "NN$er~=M#Cv4GkTewK4`",
      "name": "@Map/MonsterID56"
    },
    {
      "id": "?9E[H2w!4-Hl.+PnE(_d",
      "name": "@Map/MonsterID57"
    },
    {
      "id": "uex1Q-XvF8$$T4xSrZW$",
      "name": "@Map/MonsterID58"
    },
    {
      "id": "ijKX[Yv+Z~sN*7Zk1~ic",
      "name": "@Map/MonsterID59"
    },
    {
      "id": "e(9/61tLj{IxJyU,H(ho",
      "name": "@Map/MonsterID60"
    },
    {
      "id": "a/=2unm6bePE+n5,iQL/",
      "name": "@Map/AddBuffID01"
    },
    {
      "id": "Lg9!kXf1;5]U3v+FAyt,",
      "name": "@Map/AddBuffID02"
    },
    {
      "id": "Cy[[*NwEHS[52Bo_f{/R",
      "name": "@Map/AddBuffID03"
    },
    {
      "id": "z|J.y7i{~r6Rzi/uoD]h",
      "name": "@Map/AddBuffID04"
    },
    {
      "id": ".^.ck:})UW16SG[{Ksvs",
      "name": "@Map/AddBuffID05"
    },
    {
      "id": "gg,o=5D/*[XT4K6J#Q~L",
      "name": "@Map/AddBuffID06"
    },
    {
      "id": "KLiwJdt.8tP{o]i?V(oB",
      "name": "@Map/AddBuffID07"
    },
    {
      "id": "^m0_sWZp-[=e;K-#YZ8L",
      "name": "@Map/AddBuffID08"
    },
    {
      "id": "}q{r+AiePTbqJ=%BIB.p",
      "name": "@Map/AddBuffID09"
    },
    {
      "id": "sd/iF#*|NI;Npcd!P^]7",
      "name": "@Map/AddBuffID10"
    },
    {
      "id": "L@yMXQ%pwo}C^,|PP[vk",
      "name": "@Map/AddBuffID11"
    },
    {
      "id": "Rde?g%Yv-`4KmC0=JFB}",
      "name": "@Map/AddBuffID12"
    },
    {
      "id": "?2+EKtLs-(vqT8N~Gvt7",
      "name": "@Map/AddBuffID13"
    },
    {
      "id": "X3U{?.~]z{m2$M:I-hGC",
      "name": "@Map/AddBuffID14"
    },
    {
      "id": "yP/Y9au!1rp**=5;X,j0",
      "name": "@Map/AddBuffID15"
    },
    {
      "id": "G~jPz}||3HqPTBHnxf(C",
      "name": "@Map/AddBuffID16"
    },
    {
      "id": "W$0gpZa/hly8MXn7bQL:",
      "name": "@Map/AddBuffID17"
    },
    {
      "id": "vf@5Pz{!!g)_3-Pk!D,2",
      "name": "@Map/AddBuffID18"
    },
    {
      "id": "}7kWik(d+S?`Iu|q=reG",
      "name": "@Map/AddBuffID19"
    },
    {
      "id": "[S:4mn$nQ/gN**Zsu(3P",
      "name": "@Map/AddBuffID20"
    },
    {
      "id": "3-~PeH.;v0|[?8il7-vZ",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "ZY$6:%O|xuz0TI85N4Q-",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "FNX/IV?4F5wQBNF?-iR^",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "k=C7TU6VF_|e~RjlV6o6",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "C|8mb9(3CZUeF0Ft0.ys",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "7Y5rVVC|1`tO@[xs~FXM",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "|,MAEB/sY4=YO:|BJ9eL",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "/N}w]OzO$[ja75V*qc;T",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "~CkA5l=rLkRMcOd7JV_*",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "la;hl-Hp4b;=[z+A_p!B",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "SkE?jr^-0*!~RsHa)wxg",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "T#78^#i=[S!ZJSrl|7Xc",
      "name": "@Map/MonsterID61"
    },
    {
      "id": "JgjDU~G1OdoCBX(2Vu#E",
      "name": "@Map/MonsterID62"
    },
    {
      "id": "e!b{7$W;,dwgDwVj~B~u",
      "name": "@Map/MonsterID63"
    },
    {
      "id": "?4Gj}@^U.i#h1}qf:P2(",
      "name": "@Map/MonsterID64"
    },
    {
      "id": "P{V}!K/mHSJ#|w8v@mG!",
      "name": "@Map/MonsterID65"
    },
    {
      "id": ".zR~K|RfS2*mmd5}w:w(",
      "name": "@Map/MonsterID66"
    },
    {
      "id": "dGctzf;/9KS($(HoREfe",
      "name": "Map/BattleValue"
    },
    {
      "id": "UUPFGH$+c75Af{3jNA2d",
      "name": "Map/IsClear"
    },
    {
      "id": "+W^E=1pSe^b8Z_w#f)bn",
      "name": "Map/WaveCount"
    },
    {
      "id": "~|r1{.w/jjfXLZ~MNhh0",
      "name": "Map/WaveTick"
    },
    {
      "id": "?e=$U;p3|~E{$|o8ow.8",
      "name": "Map/IsSpawn"
    },
    {
      "id": "D*+P;Ov=Eyrc57T{U6;D",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "8]Gh{f~*9fAuAU3/w~*R",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "HZI4qAUyM`R7mTWWx-+b",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "9!?._`a@rWA*Ku6o*?mW",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "{ms[Ou:b|D)A5n0$lcu^",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "1Urg@7Me@,SJ:^Ls?Q6l",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "3Z]@?nX*j!%4W2WOLCJw",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "5{:/9==0hR,-Uy_yBg^%",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "=oVPe,t{)^B,iH.5`*a_",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "@Jil_z=a]m=hsIY=J7f8",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "/0r/q?B_`s?j_nRSP$6W",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "c:iJ71;~F4AVjjj(::=p",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "V,o%G5@FaNd.zL#bqlo}",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "C{%e];5M(wPIf:{OP=tp",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "pl:GL7g|}2`*oK0oO;x)",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "0+HtLUOEFopJQmR^-Li.",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "_dDKvs6q][Q;ut3:yP0t",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": ");SahaBQ8F|w#~lA4mVo",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "iwFxvxo4BXrta*(yb=80",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "TUd(pH;moGPe4N0Y7%2f",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "98|uh?Ctq$H,E|w,awL]",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "WmwPb(!fNp?1Z{1%9.%e",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": ",o%%@@Ri~i6w]fLTIRJ`",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "Tu/UHff4ez!,[/?(WWp?",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "Vh3gfo`W*h6ol:$_`HE3",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "iPBFe%ApVD/|^}FV~rU@",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "Fbrs0FEw3MnJQ4^@FfG#",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "dCV~TRv~?ll~R${(q,pU",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "yJ]gN8iE2Q4Vwb$KG~6,",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "uyUNfpB#yDeJxnra:{:v",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "n!|E2~I-Bnp$[_ApG5%i",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "UtSomstf,C{v4DcDi(Vu",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "nbD_-X4sbb;^IK[6@g=h",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "VUka[42EFp50qWbA+4oz",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "n8d3;7GaV{KNWB2)X2yb",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "]QA.[Pb6CgN:2#?nhh9^",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "cc;ER_BlzYr=#r.M{?]r",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "Y_|7Sa:c#7hb1:h2IL$D",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": "YufAZbv99NnDu9sl7uWc",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "R?(;qBfa:2yn$c}x*MZi",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "=eXD.2O#Ytd9a_txOyj_",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "uCd{`Zs@q]u{D$(9zQLA",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "bw+i7X#wOhE[2rH^Uq(A",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "fDQ~hn(ZsQ$gAWgm1D1)",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "UrK)PlHa:ss6|g|ZqhZ~",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "zAAK-P*P+Ckat9}[T3X)",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "Pptb[XOGhR{5g(XnUaM!",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "$E@D/Daz%Wdr(X%8N9;u",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "pTB/o.*!CI-Sx|O{Rf0!",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "ag?/+}/71w?ZHt;9TWb}",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "qadZGN}3@ZiB/8]C+F/)",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "cY7J}%@6pnSzC35D(9zM",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "`A)]*~mvnYX5h{50h+vK",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "=GCn@nGGekPdR9Sg,Y8W",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "Gye#8alR_HXd|U-Wc-kR",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "]7Myn#}O:3y`W?w)O+{:",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "]OY%H9M)[GFF7=%9~;EX",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "|2Kv#5nt.~SgE*jgW%-K",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "h9oHf4RMWsL/wX-Vn(x4",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": ".DRhbsqy*mb#^(-O8Uuh",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "qvimofqHqxKsAaQg_zpn",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "Zb4|zQwuo9E!sYLr?84-",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "u,P`$TgarQ?`KzwuiS#Q",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "5Ew0[`ggTUw6/36YavKW",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "HrQH8_-?U!4Ary$5pwE7",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": "OnDGmqZFU}ML*/`rt7!;",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "IJ*H/jjR`FlJ.,rH_J|{",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": ":j7%a4#]ijKzVR=d^z}o",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "4B}d,sRMM}Lg4_Om*NpM",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "zRmm{hUuEsu.ACR(Kkb;",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "Zh4v/QQE._KKc1=pq:xm",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "o(j7TAxw5n.GDWHWd,e/",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "G|Y`^}06I+J+@ZtD|L0g",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "O_PCsZVD.)x/N4BBGSgi",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "s;o9AaT_SxJB_GoNkvPg",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "-ECKy6.v/8*yR1HYc1Rp",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "i|S-F+fn+4`qTMA3|(l-",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": "v]u[z-!V9pX8UwG!,)jo",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "?g|#bNI{jr(r2stbns^s",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "Bfd:-1tHj{?+Nb916pH5",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "Q$i:/8:x0ptG;0XQ8?Hv",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": "%-fEe;h_9aKMU82=Gque",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "p:Mk`4/]b.lx19cc1rjm",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": ")X]8P%^?F{7-j6m5#]il",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": ")2/`r%_q=i=-jNhg}@TH",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "hlKjKfOg4TR0*9G0EoYU",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "W~8FHlu5)HP6}Xb|X_n+",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "DH@D@+:gza`1(11*ndm|",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "2V5=9Cor{q]:3%}:ttn_",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "p~H]Hike{1^s:ocL7YlV",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "%ijNIxEQHIF0]1HGuz3d",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "7;sU``I$VB~pg?q5)F}d",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "/4laYND}@m;A;;5|8n?g",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "$3Ws/ZcCoH)EG^FV%0Dc",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "//*.WG+1`kQVO4lITlrR",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "mhX0dpCBtJ%MVW*CErxR",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "hIe#KeZ@]=vaOHS@e1b4",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "7Q{Q^_Li?Jr{s^_gxnbT",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "Jt4x7R*;vwK)H-8]b*mV",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "^{A(s(h4:n4X.LiiLBM@",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "}Y`;J*:ysZ|Hj=9a$%;a",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "#nfI.#=i_kbqE~)%;H]2",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "0B/fHWt]v}78axn^K]$$",
      "name": "@Unit/Variable01"
    },
    {
      "id": "|WIaR,!BT3e,5R/u~fg9",
      "name": "@Unit/Variable02"
    },
    {
      "id": "D8Gkb*Ug{@+{k{YZT~TI",
      "name": "@Unit/Variable03"
    },
    {
      "id": "NO0l`LkFLmI5n)pWhW]@",
      "name": "@Unit/Variable04"
    },
    {
      "id": ";]f(BX3AsEXIwftip{9!",
      "name": "@Unit/Variable05"
    },
    {
      "id": "(udm_NB?O;ZGIJwH[a2d",
      "name": "@Map/Variable01"
    },
    {
      "id": "0iDCQ#{^R*Ukw~jEalY*",
      "name": "@Map/Variable02"
    },
    {
      "id": "DeB$WuMc(P?GRDD=n=rr",
      "name": "@Map/Variable03"
    },
    {
      "id": ":?mFu5o.J_M#+Bwf?JIB",
      "name": "@Map/Variable04"
    },
    {
      "id": "J;tNV~ZYN7cwm2m^o?Z~",
      "name": "@Map/Variable05"
    },
    {
      "id": "1]r]Xn)AAl=F$4dw|IJ6",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": ",]NAK3DmU_5sA3mH@GI^",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "6v?u4(w7Gn5c`tDCf!i*",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": ":#1~Gdk/9qWJh)Xm.x#u",
      "name": "Map/WaveStartTick"
    },
    {
      "id": "D:n)%@OhAx:eAD`pAb.!",
      "name": "@Skill/Trait/BlastIncreaseKBPercent"
    },
    {
      "id": "[dd2?$T8:uj:xYQ]oW~9",
      "name": "Gem"
    },
    {
      "id": ".1rChZE4lA+boZCqGRk0",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "]l4py+dPqWs?jY)F#5`r",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "F.UQF+:PQE_CyCn9rGN_",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "n:unbHPl+h8r04@654`!",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "k@k3qDGl**2i;K/.x)[f",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "`?AHX(a-Dbk]gaZ|V,=+",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "UhOLPKcp)?1s#VS*MvPB",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "-(a89U{R=Gxv^sd=qG%w",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "!3+(7r|~xke%:GI`*Hxq",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "r5-4(Y%1B+=W3CBa`7a*",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "HCtz?n(PsyJF:/N#4kwh",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "bW!.A49pv[9@SPNs:g$3",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": ",6mg}|BIQqacw,LTu}}8",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "45?ODU+LRqPXTrYAyATY",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "z=tvK[P/wNNkGN!E]dG`",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "PI4*AAlWuoWcgc1X^ryu",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "9q}u_!|88Z~#ab0DO1]j",
      "name": "@Map/Progress"
    },
    {
      "id": "}2Kw~(Wd:-lqo$CnMk})",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "3Pavx,(3um%udBFT^2,o",
      "name": "Map/Wave"
    },
    {
      "id": "_+];90#?aO5Vdgfl,g,b",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "=_PN*+aE^hfI9e=:2}Bv",
      "name": "Map/Wave/Step"
    },
    {
      "id": "T]m8b2LO82BBL%aHGnj?",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "--{xLjxRZ{fxlj~W?##T",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "L8iJ:@`JfNd^j[^^WFA-",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "JdF*E}xN3#.;R22`}:2b",
      "name": "Map/Wave/State"
    },
    {
      "id": "K1.EbyJ?/Ud%4cs8(4(]",
      "name": "Map/Player/Moving"
    },
    {
      "id": "Bcz:]w^}N[0Uye%55EZy",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "NSGtD|I{6_g/7l|UR11|",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "EhhmvQvrT^zLHy4Js)aS",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "uR|kzz?MOt)y~o{o_hgC",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "J^c~3gmawZQ@Yv9@._5]",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "MZwJ)wHg994BqOdq0U~!",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "r(W8(w#VHRDD4E-+Wzcc",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "YzC0c-^0OYopQ7xZ$)qR",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "nv#^B^l~eLEC!P^#$uVg",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "~^aTNq5,!W8/hKMU+/np",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "/QWPYa9-BwXeO@[yX=e)",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "^bhjx;NK`yMX+FWQ@yak",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "bY_}-!N{fF0*qzQ$8EV:",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "s`+TPj`vY]OYn5h|L!Ni",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "^Fh3%Yp/_DD%xDlq=0dC",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "Fo-HmOJGsm*s+x]Um%+1",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "]upy)837=0oa/KG8,`h/",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "7tXnDlXwo!Yd0wR#B~c/",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "e=|;E(eM#JWZEsq`4eFY",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "-S%6k;ziCr$!q~mBfs-v",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "gEgJQ710IJ9B[80{::AA",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "sFu.k|whR,{iUf*]yB8k",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "~i2/)s=B;0hXUq/r;VRJ",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "rAd~{yoM%rV*rg,2-`tU",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "0Ke!LLv1{x~jEJr?oytD",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": ")z#TXZpI?vxz!ti=;T-7",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "LhCf=cM|wy{jMQPAIvyp",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "RCyh:{S3_3irFA0v4ZJ]",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "(U*{K~S+{G3qaUrU0(5B",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "nFQTZ~pfZf]NbMgU-4;b",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "-(KTPG0E0hqEt$Rh}|6u",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "VkeFVGPnDScD@sN(ztE~",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "?i~IdUAM5JfqsP.belGf",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "e#n,.HMN-_Q[M@ux9x@x",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "%{[HuB5Ud:Bt23U,2#Di",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "KrM;f[Qg{ltF{2=}[fxC",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "UaD0dQ=e!+p4RiA3Staq",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": ".q]-1w;Zf###J6W!fYcI",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "uW_LXf/d]~9!h@amo:Br",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "8iP;|EpN[5ALdny{d5mQ",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "-5zn)/$tpAP*3]k,^[n5",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "a,2/z|qCx=e0C$HPCtRU",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": ")uR6]pvZAOFpani6*rdI",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "!14!:?OItGW}JDdlCfM{",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "~st[dGI{]17^9{h#)T[7",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "J?UA7qSR4ixS^Z--UH.D",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "pq_E3^S_)S=r;3NawH!_",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "35NHp76I-6ab_`[Me|wZ",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "h8gv6Rq$7qi`HLh);Qwu",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "ReS0/Kw$Uoyh3T=akVhO",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "-_/H::;6Hp+lL@lg[U_)",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "taNp=WBdEcQpB.p76;gP",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "0t_JdJa]ZE@-/wv66J=L",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "[[_z,yFf=RQ`;-zoGuD)",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "s4jmggyt[cx}r{va_YNr",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "CXMFA3307c*F{LxL^6cH",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "0,~k,f46PKy3)FB1h1rE",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "MQ:{,ap7z$=7cA{IR5r`",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "H__^F=JqOJ)!jd,Vlc0c",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "9Ft/=ALeZ0xquU/v|_71",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "zgTRn,X$Qdi{}|j^GyN9",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": ".48p6-1uNg5duS^`On0^",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "Fhzs]N4aPt[`u#=(Z^Ha",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "9Mo8}_8-,$%(/z)?j):[",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "H2=?/=wY].lpWHJ)@!cQ",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "M-wig*3Rmy5oDl4An.[G",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "iS:oCo[d_4QRM0v0V#b)",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "pzc5*D3%cTe#|^=2@%ea",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "j8uD3[VOSNv8kVF.H649",
      "name": "@Map/Player/InitUseSkill3"
    }
  ]
}