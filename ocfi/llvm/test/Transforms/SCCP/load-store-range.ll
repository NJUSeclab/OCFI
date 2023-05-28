; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -ipsccp -S | FileCheck %s

declare void @use(i1)

@G = internal global i32 0

define void @test1a() {
; CHECK-LABEL: @test1a(
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* @G
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i32 [[X]], 20
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    ret void
;
  %X = load i32, i32* @G
  %t.1 = icmp ne i32 %X, 124
  call void @use(i1 %t.1)
  %t.2 = icmp ult i32 %X, 124
  call void @use(i1 %t.2)
  %f.1 = icmp eq i32 %X, 124
  call void @use(i1 %f.1)
  %f.2 = icmp ugt i32 %X, 123
  call void @use(i1 %f.2)
  %c.1 = icmp eq i32 %X, 20
  call void @use(i1 %c.1)
  ret void
}

define void @test1b(i1 %c) {
; CHECK-LABEL: @test1b(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       T:
; CHECK-NEXT:    store i32 17, i32* @G
; CHECK-NEXT:    ret void
; CHECK:       F:
; CHECK-NEXT:    store i32 123, i32* @G
; CHECK-NEXT:    ret void
;
  br i1 %c, label %T, label %F
T:
  store i32 17, i32* @G
  ret void
F:
  store i32 123, i32* @G
  ret void
}


@H = internal global i32 0

define void @test2a() {
; CHECK-LABEL: @test2a(
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* @H
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i32 [[X]], 20
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    ret void
;
  %X = load i32, i32* @H
  %t.1 = icmp ne i32 %X, 124
  call void @use(i1 %t.1)
  %t.2 = icmp ult i32 %X, 124
  call void @use(i1 %t.2)
  %f.1 = icmp eq i32 %X, 124
  call void @use(i1 %f.1)
  %f.2 = icmp ugt i32 %X, 123
  call void @use(i1 %f.2)
  %c.1 = icmp eq i32 %X, 20
  call void @use(i1 %c.1)
  ret void
}

define void @test2b(i1 %c.1, i1 %c.2) {
; CHECK-LABEL: @test2b(
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       T:
; CHECK-NEXT:    br i1 [[C_2:%.*]], label [[T_1:%.*]], label [[F_1:%.*]]
; CHECK:       T.1:
; CHECK-NEXT:    store i32 17, i32* @H
; CHECK-NEXT:    ret void
; CHECK:       F.1:
; CHECK-NEXT:    store i32 20, i32* @H
; CHECK-NEXT:    ret void
; CHECK:       F:
; CHECK-NEXT:    store i32 123, i32* @H
; CHECK-NEXT:    ret void
;
  br i1 %c.1, label %T, label %F
T:
  br i1 %c.2, label %T.1, label %F.1

T.1:
  store i32 17, i32* @H
  ret void

F.1:
  store i32 20, i32* @H
  ret void

F:
  store i32 123, i32* @H
  ret void
}


@I = internal global i32 0

define void @test3a() {
; CHECK-LABEL: @test3a(
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* @I
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i32 [[X]], 20
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    ret void
;
  %X = load i32, i32* @I
  %t.1 = icmp ne i32 %X, 124
  call void @use(i1 %t.1)
  %t.2 = icmp ult i32 %X, 124
  call void @use(i1 %t.2)
  %f.1 = icmp eq i32 %X, 124
  call void @use(i1 %f.1)
  %f.2 = icmp ugt i32 %X, 123
  call void @use(i1 %f.2)
  %c.1 = icmp eq i32 %X, 20
  call void @use(i1 %c.1)
  ret void
}

define void @test3b(i1 %c.1, i1 %c.2) {
; CHECK-LABEL: @test3b(
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       T:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       F:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ 17, [[T]] ], [ 123, [[F]] ]
; CHECK-NEXT:    store i32 [[P]], i32* @I
; CHECK-NEXT:    ret void
;
  br i1 %c.1, label %T, label %F

T:
  br label %exit

F:
  br label %exit

exit:
  %p = phi i32 [ 17, %T ], [ 123, %F ]
  store i32 %p, i32* @I
  ret void

}

; Make sure stored values are correctly updated to overdefined.
@J = internal global i32 0

define void @test4a() {
; CHECK-LABEL: @test4a(
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* @J
; CHECK-NEXT:    [[C_1:%.*]] = icmp ne i32 [[X]], 124
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    [[C_2:%.*]] = icmp ult i32 [[X]], 124
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[C_3:%.*]] = icmp eq i32 [[X]], 124
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    [[C_4:%.*]] = icmp ugt i32 [[X]], 123
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    [[C_5:%.*]] = icmp eq i32 [[X]], 20
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    ret void
;
  %X = load i32, i32* @J
  %c.1 = icmp ne i32 %X, 124
  call void @use(i1 %c.1)
  %c.2 = icmp ult i32 %X, 124
  call void @use(i1 %c.2)
  %c.3 = icmp eq i32 %X, 124
  call void @use(i1 %c.3)
  %c.4 = icmp ugt i32 %X, 123
  call void @use(i1 %c.4)
  %c.5 = icmp eq i32 %X, 20
  call void @use(i1 %c.5)
  ret void
}

define void @test4b(i1 %c.1, i1 %c.2, i32 %x) {
; CHECK-LABEL: @test4b(
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       T:
; CHECK-NEXT:    br i1 [[C_2:%.*]], label [[T_1:%.*]], label [[F_1:%.*]]
; CHECK:       T.1:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       F.1:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       F:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ 17, [[T_1]] ], [ [[X:%.*]], [[F_1]] ], [ 123, [[F]] ]
; CHECK-NEXT:    store i32 [[P]], i32* @J
; CHECK-NEXT:    ret void
;
  br i1 %c.1, label %T, label %F
T:
  br i1 %c.2, label %T.1, label %F.1

T.1:
  br label %exit

F.1:
  br label %exit

F:
  br label %exit

exit:
  %p = phi i32 [ 17, %T.1 ], [ %x, %F.1 ], [ 123, %F ]
  store i32 %p, i32* @J
  ret void
}

; Same as test1, but storing 4 different values.

@K = internal global i32 501

define void @test5a() {
; CHECK-LABEL: @test5a(
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* @K
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i32 [[X]], 510
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    ret void
;
  %X = load i32, i32* @K
  %t.1 = icmp ne i32 %X, 499
  call void @use(i1 %t.1)
  %t.2 = icmp ult i32 %X, 600
  call void @use(i1 %t.2)
  %f.1 = icmp eq i32 %X, 600
  call void @use(i1 %f.1)
  %f.2 = icmp ugt i32 %X, 600
  call void @use(i1 %f.2)
  %c.1 = icmp eq i32 %X, 510
  call void @use(i1 %c.1)
  ret void
}

define void @test5b(i1 %c.1, i1 %c.2) {
; CHECK-LABEL: @test5b(
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[T_1:%.*]], label [[F_1:%.*]]
; CHECK:       T.1:
; CHECK-NEXT:    br i1 [[C_2:%.*]], label [[T_2:%.*]], label [[F_2:%.*]]
; CHECK:       T.2:
; CHECK-NEXT:    store i32 500, i32* @K
; CHECK-NEXT:    ret void
; CHECK:       F.2:
; CHECK-NEXT:    store i32 510, i32* @K
; CHECK-NEXT:    ret void
; CHECK:       F.1:
; CHECK-NEXT:    br i1 [[C_2]], label [[T_3:%.*]], label [[F_3:%.*]]
; CHECK:       T.3:
; CHECK-NEXT:    store i32 520, i32* @K
; CHECK-NEXT:    ret void
; CHECK:       F.3:
; CHECK-NEXT:    store i32 530, i32* @K
; CHECK-NEXT:    ret void
;
  br i1 %c.1, label %T.1, label %F.1

T.1:
  br i1 %c.2, label %T.2, label %F.2

T.2:
  store i32 500, i32* @K
  ret void

F.2:
  store i32 510, i32* @K
  ret void

F.1:
  br i1 %c.2, label %T.3, label %F.3

T.3:
  store i32 520, i32* @K
  ret void

F.3:
  store i32 530, i32* @K
  ret void
}