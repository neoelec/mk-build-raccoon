# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2026 YOUNGJIN JOO (neoelec@gmail.com)

ifndef _MK_UTILS_MK_
_MK_UTILS_MK_ := 1

UTILS_MK_FILE		:= $(abspath $(lastword $(MAKEFILE_LIST)))
UTILS_MK_DIR		:= $(patsubst %/,%,$(dir $(UTILS_MK_FILE)))

# ============================================================================
# Kbuild-style Build Verbosity Control
# ============================================================================
#   V=0 (default): quiet build output (clean command banners)
#   V=1: verbose output (print full command lines)
ifeq ($(V),1)
  Q			:=
  quiet			:=
else
  Q			:= @
  quiet			:= quiet_
endif

# ============================================================================
# Utility Functions (Kbuild / ChibiOS style)
# ============================================================================

# Order-preserving list deduplication (Kbuild strip-duplicates)
# Usage: $(call uniq,$(LIST))
uniq = $(strip $(if $(1),$(firstword $(1)) $(call uniq,$(filter-out $(firstword $(1)),$(1)))))

# Assert condition: $(call assert,condition,error message)
assert = $(if $(1),,$(error [mk-raccoon] Assertion failed: $(2)))

# Assert variable is not empty: $(call assert-not-empty,VARIABLE_NAME,Description)
assert-not-empty = $(if $(strip $($(1))),,$(error [mk-raccoon] Variable '$(1)' must not be empty$(if $(2), ($(2)))))

# Fast pure-Make uppercase conversion (zero parse-time subshells)
# Usage: $(call uc,string)
uc = $(subst a,A,$(subst b,B,$(subst c,C,$(subst d,D,$(subst e,E,$(subst f,F,$(subst g,G,$(subst h,H,$(subst i,I,$(subst j,J,$(subst k,K,$(subst l,L,$(subst m,M,$(subst n,N,$(subst o,O,$(subst p,P,$(subst q,Q,$(subst r,R,$(subst s,S,$(subst t,T,$(subst u,U,$(subst v,V,$(subst w,W,$(subst x,X,$(subst y,Y,$(subst z,Z,$(1)))))))))))))))))))))))))))

# Fast pure-Make lowercase conversion (zero parse-time subshells)
# Usage: $(call lc,string)
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$(1)))))))))))))))))))))))))))

endif # _MK_UTILS_MK_
