/* Generated by Yosys 0.24+1 (git sha1 7ad7b550c, clang 14.0.0-1ubuntu1 -fPIC -Os) */

module dom_indep_d1_yosys(clk, port_a, port_b, port_c, port_r);
  wire _00_;
  wire _01_;
  wire \U0.A1 ;
  wire \U0.A2 ;
  wire \U0.ZN ;
  wire \U1.A1 ;
  wire \U1.A2 ;
  wire \U1.ZN ;
  wire \U2.A1 ;
  wire \U2.A2 ;
  wire \U2.ZN ;
  wire \U3.A1 ;
  wire \U3.A2 ;
  wire \U3.ZN ;
  wire \U4.A ;
  wire \U4.B ;
  wire \U4.Z ;
  wire \U5.A ;
  wire \U5.B ;
  wire \U5.Z ;
  wire \U6.CK ;
  wire \U6.D ;
  wire \U6.Q ;
  wire \U6.QN ;
  wire \U7.CK ;
  wire \U7.D ;
  wire \U7.Q ;
  wire \U7.QN ;
  wire \U8.A ;
  wire \U8.B ;
  wire \U8.Z ;
  wire \U9.A ;
  wire \U9.B ;
  wire \U9.Z ;
  input clk;
  wire i0;
  wire i1;
  wire i2;
  wire i3;
  wire j0;
  wire j1;
  wire l0;
  wire l1;
  input [1:0] port_a;
  input [1:0] port_b;
  output [1:0] port_c;
  input port_r;

  BUF _02_ (
    .A(i3),
    .Y(\U9.A )
  );
  BUF _03_ (
    .A(l1),
    .Y(\U9.B )
  );
  BUF _04_ (
    .A(\U9.Z ),
    .Y(port_c[1])
  );
  BUF _05_ (
    .A(i0),
    .Y(\U8.A )
  );
  BUF _06_ (
    .A(l0),
    .Y(\U8.B )
  );
  BUF _07_ (
    .A(\U8.Z ),
    .Y(port_c[0])
  );
  BUF _08_ (
    .A(clk),
    .Y(\U7.CK )
  );
  BUF _09_ (
    .A(j1),
    .Y(\U7.D )
  );
  BUF _10_ (
    .A(\U7.Q ),
    .Y(l1)
  );
  BUF _11_ (
    .A(clk),
    .Y(\U6.CK )
  );
  BUF _12_ (
    .A(j0),
    .Y(\U6.D )
  );
  BUF _13_ (
    .A(\U6.Q ),
    .Y(l0)
  );
  BUF _14_ (
    .A(i2),
    .Y(\U5.A )
  );
  BUF _15_ (
    .A(port_r),
    .Y(\U5.B )
  );
  BUF _16_ (
    .A(\U5.Z ),
    .Y(j1)
  );
  BUF _17_ (
    .A(i1),
    .Y(\U4.A )
  );
  BUF _18_ (
    .A(port_r),
    .Y(\U4.B )
  );
  BUF _19_ (
    .A(\U4.Z ),
    .Y(j0)
  );
  BUF _20_ (
    .A(port_a[1]),
    .Y(\U3.A1 )
  );
  BUF _21_ (
    .A(port_b[1]),
    .Y(\U3.A2 )
  );
  BUF _22_ (
    .A(\U3.ZN ),
    .Y(i3)
  );
  BUF _23_ (
    .A(port_a[1]),
    .Y(\U2.A1 )
  );
  BUF _24_ (
    .A(port_b[0]),
    .Y(\U2.A2 )
  );
  BUF _25_ (
    .A(\U2.ZN ),
    .Y(i2)
  );
  BUF _26_ (
    .A(port_a[0]),
    .Y(\U1.A1 )
  );
  BUF _27_ (
    .A(port_b[1]),
    .Y(\U1.A2 )
  );
  BUF _28_ (
    .A(\U1.ZN ),
    .Y(i1)
  );
  BUF _29_ (
    .A(port_a[0]),
    .Y(\U0.A1 )
  );
  BUF _30_ (
    .A(port_b[0]),
    .Y(\U0.A2 )
  );
  BUF _31_ (
    .A(\U0.ZN ),
    .Y(i0)
  );
  AND _32_ (
    .A(\U0.A2 ),
    .B(\U0.A1 ),
    .Y(\U0.ZN )
  );
  AND _33_ (
    .A(\U1.A2 ),
    .B(\U1.A1 ),
    .Y(\U1.ZN )
  );
  AND _34_ (
    .A(\U2.A2 ),
    .B(\U2.A1 ),
    .Y(\U2.ZN )
  );
  AND _35_ (
    .A(\U3.A2 ),
    .B(\U3.A1 ),
    .Y(\U3.ZN )
  );
  XOR _36_ (
    .A(\U4.B ),
    .B(\U4.A ),
    .Y(\U4.Z )
  );
  XOR _37_ (
    .A(\U5.B ),
    .B(\U5.A ),
    .Y(\U5.Z )
  );
  NOT _38_ (
    .A(\U6.D ),
    .Y(_00_)
  );
  DFF _39_ (
    .C(\U6.CK ),
    .D(\U6.D ),
    .Q(\U6.Q )
  );
  DFF _40_ (
    .C(\U6.CK ),
    .D(_00_),
    .Q(\U6.QN )
  );
  NOT _41_ (
    .A(\U7.D ),
    .Y(_01_)
  );
  DFF _42_ (
    .C(\U7.CK ),
    .D(\U7.D ),
    .Q(\U7.Q )
  );
  DFF _43_ (
    .C(\U7.CK ),
    .D(_01_),
    .Q(\U7.QN )
  );
  XOR _44_ (
    .A(\U8.B ),
    .B(\U8.A ),
    .Y(\U8.Z )
  );
  XOR _45_ (
    .A(\U9.B ),
    .B(\U9.A ),
    .Y(\U9.Z )
  );
endmodule
