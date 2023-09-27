PROGRAM Troja;

{$path "ram:include/","pascal:include/";incl "intuition.lib",
"Graphics.lib" }

CONST
	Breite=640; Höhe=512; MEMF_CHIP=2;

TYPE
    	Vektor2 = Record
     x, y: real;
     END;

VAR
     NeuWindow:NewWindow;
     MyWindow:^Window;
     rport:^RastPort;
     flag:boolean;
     L:Long;
     MyScreen: ^Screen;
     Msg,Upt: ptr;

     mJ, mS: Real;
     Mond, Erde: Array[0..360] of Vektor2;
     si, co: Array[0..360] of real;
     Satellit, vSatellit: Vektor2;
     c,t, h: real;
     Nr,i,steps: Integer;
     Mitte: Vektor2;
     Einheit: Real;

PROCEDURE GrafikEin; {Zum Öffnen des Fensters}
BEGIN
  	OpenLib(IntBase,'intuition.library',0);
  	OpenLib(GfxBase,'graphics.library' ,0);
  	MyScreen:=Open_Screen(0,0,Breite,Höhe,1,1,2,GENLOCK_VIDEO
	+hires+lace,'Troia.p');
  	NeuWindow:=NewWindow(0,0,Breite,Höhe,0,1,VANILLAKEY,
	BORDERLESS+ACTIVATE,
       Nil,Nil,Nil,MyScreen,Nil,100,80,Breite,Höhe,CUSTOMSCREEN);
  	MyWindow:=OpenWindow(^Neuwindow);
  	IF MyWindow=Nil THEN Error('Fenster kann nicht geöffnet
	werden!');
  	SetRGB4(^MyScreen^.ViewPort,0,0,0,0);
  	SetRGB4(^MyScreen^.ViewPort,1,15,15,15);
  	SetRGB4(^MyScreen^.ViewPort,2,15,15,15);

  	rport:=MyWindow^.RPort;
  	Upt:=MyWindow^.Userport;
END; {GrafikEin}

PROCEDURE Taste;
BEGIN
     Msg:=Wait_Port(Upt);
     Msg:=Get_Msg(Upt);
     Reply_Msg(Msg);
END; {Taste}

PROCEDURE Inc360 (VAR i: Integer);
BEGIN
     i:=i+1;
     IF i=360 THEN
     i:=0
END;


PROCEDURE Eingabe;
BEGIN
     writeln("Programm : TROIA");
     writeln;

     REPEAT
        write("Eingabe des Massenverhältnisses c:");
        readln(c);
     UNTIL (c<1) and (c>0);

     writeln;
     REPEAT
        write("Wieviele Schritte ?");
        readln(steps);
     UNTIL (steps>0) and (steps <10001);
        writeln;

END; {Eingabe}

PROCEDURE initSiCo;
VAR
  i: Integer;
  arc: Real;
BEGIN
     arc:= 3.14159265359 /180.0;
     FOR i:=0 TO 90 DO
     BEGIN
     	si[i]:= sin(arc*i);
          si[180 - i] := si[i];
          si[180 + i] := -si[i];
          si[360 - i] := -si[i];

          co[i]:= cos(arc*i);
          co[360 - i] := co[i];
          co[180 + i] := -co[i];
          co[180 - i] := -co[i];

     END;
END; {initSiCo}

Function f0(rp:real):real;
BEGIN
        f0:=(1-c)/sqr(c+rp)-c/sqr(1-c-rp)-rp;
END; {f0}

Function f1(rp:real):real;
BEGIN
        f1:=2*(c-1)/sqr(c+rp)/(c+rp)-2*c/sqr(1-c-rp)/(1-c-rp)-1;
END; {f1}

PROCEDURE Anfangswerte;
VAR
   d,r:Real;
   xa,x,y,c,t,m:real
   i:integer;

BEGIN

    x:=0

    REPEAT     { Newtonsches Iterationsverfahren zur Berechnung
			  der Nullstelle}
       xa:=x;m:=f1(x);y:=f0(x);
       t:=y-m*x;
       x:=-t/m
    UNTIL abs(f0(x))<0.001;

    writeln("Nullstelle: f(",x,") = ",f0(x));


    Satellit.x:=0;
    Satellit.y:=x;
    vSatellit.x:=-x;
    vSatellit.y:=0;


    Mitte.x:=Breite/2.5;
    Mitte.y:=Höhe/2;
    Einheit:=Breite/2;
END;

PROCEDURE Init;
VAR
  i: Integer;
BEGIN
    mJ:=c;
    mS:= 1.0 - mJ

    FOR i:= 0 TO 360 DO
    BEGIN
        Mond[i].x := -si[i] * mS;
        Mond[i].y := co[i] * mS;
        Erde[i].x := si[i] * mJ;
        Erde[i].y := -co[i] * mJ;
    END;

    t := 0.0;
    Nr := 0;
    h  := 3.1415926 /90.0;

    Anfangswerte;

END; {init}

PROCEDURE Plot (s: Vektor2);
BEGIN {Plot}
        Draw(rport,Round((s.y * co[Nr] - s.x * si[Nr]) * Einheit
		   + Mitte.x),Round((s.x * co[Nr] + s.y * si[Nr]) *
		   Einheit + Mitte.y));
END; {Plot}

PROCEDURE PlotStart (s: Vektor2);
BEGIN {PlotStart}
        Move(rport,Round((s.y * co[Nr] - s.x * si[Nr]) * Einheit
		   + Mitte.x), Round((s.x * co[Nr] + s.y * si[Nr]) *
		   Einheit + Mitte.y));
END; {PlotStart}



PROCEDURE PlotJuSo;
VAR
x0,y0: Integer;
BEGIN
     x0 := Round(Erde[0].y* Einheit + Mitte.x);
     y0 := Round(Erde[0].x* Einheit + Mitte.y);
     RectFill(rport,x0-1,y0-1,x0+2,y0+1);
     Move(rport,x0+5,y0+2);
     flag:=Text(rport,'Erde',4);

     x0 := Round(Mond[0].y* Einheit + Mitte.x);
     y0 := Round(Mond[0].x* Einheit + Mitte.y);
     RectFill(rport,x0-1,y0-1,x0+2,y0+1);
     Move(rport,x0+5,y0+2);
     flag:=Text(rport,'Mond',4);
END; {PlotJuSo}

PROCEDURE f (Satellit: Vektor2;VAR a:Vektor2);
VAR
  rJ2, rS2, rJ3, rS3: Real;
  rJ, rS: Vektor2;
BEGIN
     rJ.x := Mond[Nr].x - Satellit.x;
     rJ.y := Mond[Nr].y - Satellit.y;
     rS.x := Erde[Nr].x - Satellit.x;
     rS.y := Erde[Nr].y - Satellit.y;
     rJ2 := sqr(rJ.x) + sqr(rJ.y);
     rS2 := sqr(rS.x) + sqr(rS.y);
     rJ3 := rJ2 * sqrt(rJ2);
     rS3 := rS2 * sqrt(rS2);
     a.x := mS * rS.x / rS3 + mJ * rJ.x /rJ3;
     a.y := mS * rS.y / rS3 + mJ * rJ.y /rJ3;
END;


PROCEDURE Nyström2 (VAR s,v:Vektor2;,t,h:real);
VAR
  h2: Real;
  k1,k2,k4,x1,a1,a2,a3: Vektor2;
BEGIN
        h2 := h * 0.5;
        f(s,a1);

        k1.x := a1.x * h2;
        k1.y := a1.y * h2;
        t := t + h2;
        x1.x := s.x + (v.x + k1.x *0.5) *h2;
        x1.y := s.y + (v.y + k1.y *0.5) *h2;
        Inc360(Nr);
        f(x1,a2);

        k2.x := a2.x * h2;
        k2.y := a2.y * h2;
        t := t + h2;
        x1.x := s.x + (v.x + k2.x) * h;
        x1.y := s.y + (v.y + k2.y) * h;
        Inc360(Nr);
        f(x1,a3);

        k4.x := a3.x * h2;
        k4.y := a3.y * h2;

        s.x := s.x + (v.x + (k1.x + k2.x * 2)/3) * h;
       