; RUN: opt %loadNPMPolly -passes=polly-codegen -S %s | FileCheck %s
;
; This test was extracted from gcc in SPEC2006 and it crashed our code
; generation, or to be more precise, the ScopExpander due to a endless
; recursion. It was fixed in r261474 (git: 61cba205ca59).
;
; CHECK: polly.start:
;
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define void @lex_number(ptr %str) {
entry:
  br label %for.end

for.end:                                          ; preds = %entry
  %0 = load i8, ptr %str, align 1
  %cmp17 = icmp eq i8 %0, 48
  br i1 %cmp17, label %land.lhs.true34, label %lor.lhs.false81

land.lhs.true34:                                  ; preds = %for.end
  %arrayidx35 = getelementptr inbounds i8, ptr %str, i64 1
  %str.arrayidx35 = select i1 undef, ptr %str, ptr %arrayidx35
  br label %lor.lhs.false81

lor.lhs.false81:                                  ; preds = %land.lhs.true34, %for.end
  %p.0 = phi ptr [ %str.arrayidx35, %land.lhs.true34 ], [ %str, %for.end ]
  br label %do.body172

do.body172:                                       ; preds = %lor.lhs.false81
  ret void
}
