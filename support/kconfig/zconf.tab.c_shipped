/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */


/*
 * Copyright (C) 2002 Roman Zippel <zippel@linux-m68k.org>
 * Released under the terms of the GNU GPL v2.0.
 */

#include <ctype.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#include "lkc.h"

#define printd(mask, fmt...) if (cdebug & (mask)) printf(fmt)

#define PRINTD		0x0001
#define DEBUG_PARSE	0x0002

int cdebug = PRINTD;

int yylex(void);
static void yyerror(const char *err);
static void zconfprint(const char *err, ...);
static void zconf_error(const char *err, ...);
static bool zconf_endtoken(const struct kconf_id *id, int starttoken, int endtoken);

struct symbol *symbol_hash[SYMBOL_HASHSIZE];

static struct menu *current_menu, *current_entry;




# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif


/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    T_MAINMENU = 258,
    T_MENU = 259,
    T_ENDMENU = 260,
    T_SOURCE = 261,
    T_CHOICE = 262,
    T_ENDCHOICE = 263,
    T_COMMENT = 264,
    T_CONFIG = 265,
    T_MENUCONFIG = 266,
    T_HELP = 267,
    T_HELPTEXT = 268,
    T_IF = 269,
    T_ENDIF = 270,
    T_DEPENDS = 271,
    T_OPTIONAL = 272,
    T_PROMPT = 273,
    T_TYPE = 274,
    T_DEFAULT = 275,
    T_SELECT = 276,
    T_IMPLY = 277,
    T_RANGE = 278,
    T_VISIBLE = 279,
    T_OPTION = 280,
    T_ON = 281,
    T_WORD = 282,
    T_WORD_QUOTE = 283,
    T_UNEQUAL = 284,
    T_LESS = 285,
    T_LESS_EQUAL = 286,
    T_GREATER = 287,
    T_GREATER_EQUAL = 288,
    T_CLOSE_PAREN = 289,
    T_OPEN_PAREN = 290,
    T_EOL = 291,
    T_OR = 292,
    T_AND = 293,
    T_EQUAL = 294,
    T_NOT = 295
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{


	char *string;
	struct file *file;
	struct symbol *symbol;
	struct expr *expr;
	struct menu *menu;
	const struct kconf_id *id;


};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);



/* Copy the second part of user declarations.  */


/* Include kconf_id.c here so it can see the token constants. */
#include "kconf_id.c"



#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  11
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   325

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  41
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  52
/* YYNRULES -- Number of rules.  */
#define YYNRULES  126
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  206

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   295

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   110,   110,   110,   112,   112,   116,   124,   134,   136,
     137,   138,   139,   140,   141,   145,   149,   149,   149,   149,
     149,   149,   149,   149,   149,   153,   154,   155,   156,   157,
     158,   162,   163,   169,   176,   181,   188,   197,   199,   200,
     201,   202,   203,   204,   207,   215,   221,   231,   237,   243,
     249,   252,   254,   267,   268,   273,   283,   288,   296,   299,
     301,   302,   303,   304,   305,   308,   314,   325,   331,   341,
     343,   348,   356,   364,   367,   369,   370,   371,   376,   383,
     388,   396,   399,   401,   402,   403,   406,   415,   422,   427,
     433,   451,   453,   454,   455,   458,   466,   468,   469,   472,
     479,   481,   486,   487,   490,   491,   492,   496,   497,   500,
     501,   504,   505,   506,   507,   508,   509,   510,   511,   512,
     513,   514,   518,   520,   521,   524,   525
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "T_MAINMENU", "T_MENU", "T_ENDMENU",
  "T_SOURCE", "T_CHOICE", "T_ENDCHOICE", "T_COMMENT", "T_CONFIG",
  "T_MENUCONFIG", "T_HELP", "T_HELPTEXT", "T_IF", "T_ENDIF", "T_DEPENDS",
  "T_OPTIONAL", "T_PROMPT", "T_TYPE", "T_DEFAULT", "T_SELECT", "T_IMPLY",
  "T_RANGE", "T_VISIBLE", "T_OPTION", "T_ON", "T_WORD", "T_WORD_QUOTE",
  "T_UNEQUAL", "T_LESS", "T_LESS_EQUAL", "T_GREATER", "T_GREATER_EQUAL",
  "T_CLOSE_PAREN", "T_OPEN_PAREN", "T_EOL", "T_OR", "T_AND", "T_EQUAL",
  "T_NOT", "$accept", "input", "start", "mainmenu_stmt",
  "no_mainmenu_stmt", "stmt_list", "option_name", "common_stmt",
  "option_error", "config_entry_start", "config_stmt",
  "menuconfig_entry_start", "menuconfig_stmt", "config_option_list",
  "config_option", "symbol_option", "symbol_option_list",
  "symbol_option_arg", "choice", "choice_entry", "choice_end",
  "choice_stmt", "choice_option_list", "choice_option", "choice_block",
  "if_entry", "if_end", "if_stmt", "if_block", "menu", "menu_entry",
  "menu_end", "menu_stmt", "menu_block", "source_stmt", "comment",
  "comment_stmt", "help_start", "help", "depends_list", "depends",
  "visibility_list", "visible", "prompt_stmt_opt", "prompt", "end", "nl",
  "if_expr", "expr", "nonconst_symbol", "symbol", "word_opt", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295
};
# endif

#define YYPACT_NINF -92

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-92)))

#define YYTABLE_NINF -89

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
      20,    33,   -92,    16,   -92,   -92,   -92,    21,   -92,   -92,
      29,   -92,   152,   186,   -92,   -92,    40,    67,    33,    71,
      33,    42,    80,    33,    78,    78,    31,    82,   -92,   -92,
     -92,   -92,   -92,   -92,   -92,   -92,   -92,   120,   -92,   131,
     -92,   -92,   -92,   -92,   -92,   -92,   -92,   -92,   -92,   -92,
     -92,   -92,   -92,   -92,   -92,   -92,   -92,   -92,   109,   -92,
     118,   -92,   128,   -92,   129,   -92,   141,   142,   -92,    31,
      31,    74,   -92,    69,   -92,   144,   145,    28,   119,   248,
     286,    77,    38,    77,   219,   -92,   -92,   -92,   -92,   -92,
     -92,    -7,   -92,    31,    31,    40,    52,    52,    52,    52,
      52,    52,   -92,   -92,   146,   147,   158,    33,    33,    31,
      78,    78,    52,   -92,   184,   -92,   -92,   -92,   -92,   176,
     -92,   -92,   162,    33,    33,    78,   -92,   -92,   -92,   -92,
     -92,   -92,   -92,   -92,   -92,   -92,   -92,   -92,   -92,   197,
     -92,   272,   -92,   -92,   -92,   -92,   -92,   -92,   -92,   -92,
     -92,   -92,   174,   -92,   -92,   -92,   -92,   -92,   -92,   -92,
     -92,   -92,    31,   197,   178,   197,    59,   197,   197,    52,
      27,   179,   -92,   -92,   197,   180,   197,    31,   -92,   111,
     181,   -92,   -92,   182,   185,   195,   197,   193,   -92,   -92,
     208,   -92,   209,   113,   -92,   -92,   -92,   -92,   -92,   211,
      33,   -92,   -92,   -92,   -92,   -92
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       7,     0,   107,     0,     3,     8,     8,     7,   102,   103,
       0,     1,     0,     0,   108,     2,     6,     0,     0,     0,
       0,   125,     0,     0,     0,     0,     0,     0,    16,    21,
      17,    18,    23,    19,    20,    22,    24,     0,    25,     0,
       9,    37,    28,    37,    29,    59,    69,    10,    74,    26,
      96,    82,    11,    30,    91,    27,    12,    15,     0,   104,
       0,   126,     0,   105,     0,   122,     0,     0,   124,     0,
       0,     0,   123,   111,   106,     0,     0,     0,     0,     0,
       0,     0,    91,     0,     0,    78,    86,    55,    87,    33,
      35,     0,   119,     0,     0,    71,     0,     0,     0,     0,
       0,     0,    13,    14,     0,     0,     0,     0,   100,     0,
       0,     0,     0,    51,     0,    43,    42,    38,    39,     0,
      41,    40,     0,     0,   100,     0,    63,    64,    60,    62,
      61,    70,    58,    57,    75,    77,    73,    76,    72,   109,
      98,     0,    97,    83,    85,    81,    84,    80,    93,    94,
      92,   118,   120,   121,   117,   112,   113,   114,   115,   116,
      32,    89,     0,   109,     0,   109,   109,   109,   109,     0,
       0,     0,    90,    67,   109,     0,   109,     0,    99,     0,
       0,    44,   101,     0,     0,     0,   109,    53,    50,    31,
       0,    66,     0,   110,    95,    45,    46,    47,    48,     0,
       0,    52,    65,    68,    49,    54
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
     -92,   -92,   241,   -92,   -92,   244,   -92,   -13,   -66,   -92,
     -92,   -92,   -92,   218,   -92,   -92,   -92,   -92,   -92,   -92,
     -92,   -69,   -92,   -92,   -92,   -92,   -92,   -92,   -92,   -92,
     -92,   -92,    12,   -92,   -92,   -92,   -92,   -92,   172,   170,
     -64,   -92,   -92,   148,    -1,    34,     1,   139,   -68,   -21,
     -91,   -92
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     3,     4,     5,     6,    12,    39,    40,   116,    41,
      42,    43,    44,    77,   117,   118,   170,   201,    45,    46,
     132,    47,    79,   128,    80,    48,   136,    49,    81,    50,
      51,   145,    52,    83,    53,    54,    55,   119,   120,    84,
     121,    82,   142,   164,   165,    56,     7,   178,    71,    72,
      73,    62
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      10,    91,    92,    66,    67,   154,   155,   156,   157,   158,
     159,    16,   135,   127,   144,   130,    11,    58,   149,    60,
     150,   169,    64,     1,     1,   152,   153,   151,   -34,   104,
      93,    94,   -34,   -34,   -34,   -34,   -34,   -34,   -34,   -34,
     105,   166,   -34,   -34,   106,   -34,   107,   108,   109,   110,
     111,   112,   -34,   113,   187,   114,     2,    14,    65,    68,
       8,     9,   139,   188,   115,     2,    69,   131,   134,    61,
     143,    70,    95,   177,   140,   149,    14,   150,   186,    65,
      68,    18,    19,    20,    21,    22,    23,    24,    25,   167,
     168,    26,    27,   137,   179,   146,    93,    94,    96,    97,
      98,    99,   100,    57,   176,    65,   163,    59,   101,   193,
       2,    93,    94,    38,   133,   138,    63,   147,    74,   -36,
     104,    75,   174,   -36,   -36,   -36,   -36,   -36,   -36,   -36,
     -36,   105,    76,   -36,   -36,   106,   -36,   107,   108,   109,
     110,   111,   112,   -36,   113,    85,   114,   194,    93,    94,
      93,    94,    -4,    17,    86,   115,    18,    19,    20,    21,
      22,    23,    24,    25,    87,    88,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    35,    36,    89,    90,    37,
     102,   103,   160,   161,   162,   171,    -5,    17,    38,   172,
      18,    19,    20,    21,    22,    23,    24,    25,   173,   205,
      26,    27,    28,    29,    30,    31,    32,    33,    34,    35,
      36,   177,    94,    37,   181,   189,   191,   195,   196,   -88,
     104,   197,    38,   -88,   -88,   -88,   -88,   -88,   -88,   -88,
     -88,   198,   200,   -88,   -88,   106,   -88,   -88,   -88,   -88,
     -88,   -88,   -88,   -88,   202,   203,   114,   204,    15,   104,
      13,   129,   141,   -56,   -56,   148,   -56,   -56,   -56,   -56,
     105,    78,   -56,   -56,   106,   122,   123,   124,   125,     0,
       0,     0,   175,   104,     0,   114,   -79,   -79,   -79,   -79,
     -79,   -79,   -79,   -79,   126,     0,   -79,   -79,   106,     0,
       0,    19,    20,     0,    22,    23,    24,    25,     0,   114,
      26,    27,   180,     0,   182,   183,   184,   185,   148,     0,
       0,     0,     0,   190,     0,   192,     0,     0,     0,     0,
       0,     0,    38,     0,     0,   199
};

static const yytype_int16 yycheck[] =
{
       1,    69,    70,    24,    25,    96,    97,    98,    99,   100,
     101,    10,    81,    79,    83,    79,     0,    18,    84,    20,
      84,   112,    23,     3,     3,    93,    94,    34,     0,     1,
      37,    38,     4,     5,     6,     7,     8,     9,    10,    11,
      12,   109,    14,    15,    16,    17,    18,    19,    20,    21,
      22,    23,    24,    25,    27,    27,    36,    36,    27,    28,
      27,    28,    24,    36,    36,    36,    35,    80,    81,    27,
      83,    40,    71,    14,    36,   141,    36,   141,   169,    27,
      28,     4,     5,     6,     7,     8,     9,    10,    11,   110,
     111,    14,    15,    81,   162,    83,    37,    38,    29,    30,
      31,    32,    33,    36,   125,    27,   107,    36,    39,   177,
      36,    37,    38,    36,    80,    81,    36,    83,    36,     0,
       1,     1,   123,     4,     5,     6,     7,     8,     9,    10,
      11,    12,     1,    14,    15,    16,    17,    18,    19,    20,
      21,    22,    23,    24,    25,    36,    27,    36,    37,    38,
      37,    38,     0,     1,    36,    36,     4,     5,     6,     7,
       8,     9,    10,    11,    36,    36,    14,    15,    16,    17,
      18,    19,    20,    21,    22,    23,    24,    36,    36,    27,
      36,    36,    36,    36,    26,     1,     0,     1,    36,    13,
       4,     5,     6,     7,     8,     9,    10,    11,    36,   200,
      14,    15,    16,    17,    18,    19,    20,    21,    22,    23,
      24,    14,    38,    27,    36,    36,    36,    36,    36,     0,
       1,    36,    36,     4,     5,     6,     7,     8,     9,    10,
      11,    36,    39,    14,    15,    16,    17,    18,    19,    20,
      21,    22,    23,    24,    36,    36,    27,    36,     7,     1,
       6,    79,    82,     5,     6,    36,     8,     9,    10,    11,
      12,    43,    14,    15,    16,    17,    18,    19,    20,    -1,
      -1,    -1,   124,     1,    -1,    27,     4,     5,     6,     7,
       8,     9,    10,    11,    36,    -1,    14,    15,    16,    -1,
      -1,     5,     6,    -1,     8,     9,    10,    11,    -1,    27,
      14,    15,   163,    -1,   165,   166,   167,   168,    36,    -1,
      -1,    -1,    -1,   174,    -1,   176,    -1,    -1,    -1,    -1,
      -1,    -1,    36,    -1,    -1,   186
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,    36,    42,    43,    44,    45,    87,    27,    28,
      85,     0,    46,    46,    36,    43,    87,     1,     4,     5,
       6,     7,     8,     9,    10,    11,    14,    15,    16,    17,
      18,    19,    20,    21,    22,    23,    24,    27,    36,    47,
      48,    50,    51,    52,    53,    59,    60,    62,    66,    68,
      70,    71,    73,    75,    76,    77,    86,    36,    85,    36,
      85,    27,    92,    36,    85,    27,    90,    90,    28,    35,
      40,    89,    90,    91,    36,     1,     1,    54,    54,    63,
      65,    69,    82,    74,    80,    36,    36,    36,    36,    36,
      36,    89,    89,    37,    38,    87,    29,    30,    31,    32,
      33,    39,    36,    36,     1,    12,    16,    18,    19,    20,
      21,    22,    23,    25,    27,    36,    49,    55,    56,    78,
      79,    81,    17,    18,    19,    20,    36,    49,    64,    79,
      81,    48,    61,    86,    48,    62,    67,    73,    86,    24,
      36,    80,    83,    48,    62,    72,    73,    86,    36,    49,
      81,    34,    89,    89,    91,    91,    91,    91,    91,    91,
      36,    36,    26,    85,    84,    85,    89,    90,    90,    91,
      57,     1,    13,    36,    85,    84,    90,    14,    88,    89,
      88,    36,    88,    88,    88,    88,    91,    27,    36,    36,
      88,    36,    88,    89,    36,    36,    36,    36,    36,    88,
      39,    58,    36,    36,    36,    85
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    41,    42,    42,    43,    43,    44,    45,    46,    46,
      46,    46,    46,    46,    46,    46,    47,    47,    47,    47,
      47,    47,    47,    47,    47,    48,    48,    48,    48,    48,
      48,    49,    49,    50,    51,    52,    53,    54,    54,    54,
      54,    54,    54,    54,    55,    55,    55,    55,    55,    55,
      56,    57,    57,    58,    58,    59,    60,    61,    62,    63,
      63,    63,    63,    63,    63,    64,    64,    64,    64,    65,
      65,    66,    67,    68,    69,    69,    69,    69,    70,    71,
      72,    73,    74,    74,    74,    74,    75,    76,    77,    78,
      79,    80,    80,    80,    80,    81,    82,    82,    82,    83,
      84,    84,    85,    85,    86,    86,    86,    87,    87,    88,
      88,    89,    89,    89,    89,    89,    89,    89,    89,    89,
      89,    89,    90,    91,    91,    92,    92
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     1,     2,     2,     3,     0,     0,     2,
       2,     2,     2,     4,     4,     3,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     3,     2,     3,     2,     3,     2,     0,     2,     2,
       2,     2,     2,     2,     3,     4,     4,     4,     4,     5,
       3,     0,     3,     0,     2,     3,     2,     1,     3,     0,
       2,     2,     2,     2,     2,     4,     3,     2,     4,     0,
       2,     3,     1,     3,     0,     2,     2,     2,     3,     3,
       1,     3,     0,     2,     2,     2,     3,     3,     2,     2,
       2,     0,     2,     2,     2,     4,     0,     2,     2,     2,
       0,     2,     1,     1,     2,     2,     2,     1,     2,     0,
       2,     1,     3,     3,     3,     3,     3,     3,     3,     2,
       3,     3,     1,     1,     1,     0,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  switch (yytype)
    {
          case 60: /* choice_entry  */

      {
	fprintf(stderr, "%s:%d: missing end statement for this entry\n",
		((*yyvaluep).menu)->file->name, ((*yyvaluep).menu)->lineno);
	if (current_menu == ((*yyvaluep).menu))
		menu_end_menu();
}

        break;

    case 66: /* if_entry  */

      {
	fprintf(stderr, "%s:%d: missing end statement for this entry\n",
		((*yyvaluep).menu)->file->name, ((*yyvaluep).menu)->lineno);
	if (current_menu == ((*yyvaluep).menu))
		menu_end_menu();
}

        break;

    case 71: /* menu_entry  */

      {
	fprintf(stderr, "%s:%d: missing end statement for this entry\n",
		((*yyvaluep).menu)->file->name, ((*yyvaluep).menu)->lineno);
	if (current_menu == ((*yyvaluep).menu))
		menu_end_menu();
}

        break;


      default:
        break;
    }
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 6:

    {
	menu_add_prompt(P_MENU, (yyvsp[-1].string), NULL);
}

    break;

  case 7:

    {
	/*
	 * Hack: Keep the main menu title on the heap so we can safely free it
	 * later regardless of whether it comes from the 'prompt' in
	 * mainmenu_stmt or here
	 */
	menu_add_prompt(P_MENU, xstrdup("Buildroot Configuration"), NULL);
}

    break;

  case 12:

    { zconf_error("unexpected end statement"); }

    break;

  case 13:

    { zconf_error("unknown statement \"%s\"", (yyvsp[-2].string)); }

    break;

  case 14:

    {
	zconf_error("unexpected option \"%s\"", (yyvsp[-2].id)->name);
}

    break;

  case 15:

    { zconf_error("invalid statement"); }

    break;

  case 31:

    { zconf_error("unknown option \"%s\"", (yyvsp[-2].string)); }

    break;

  case 32:

    { zconf_error("invalid option"); }

    break;

  case 33:

    {
	(yyvsp[-1].symbol)->flags |= SYMBOL_OPTIONAL;
	menu_add_entry((yyvsp[-1].symbol));
	printd(DEBUG_PARSE, "%s:%d:config %s\n", zconf_curname(), zconf_lineno(), (yyvsp[-1].symbol)->name);
}

    break;

  case 34:

    {
	printd(DEBUG_PARSE, "%s:%d:endconfig\n", zconf_curname(), zconf_lineno());
}

    break;

  case 35:

    {
	(yyvsp[-1].symbol)->flags |= SYMBOL_OPTIONAL;
	menu_add_entry((yyvsp[-1].symbol));
	printd(DEBUG_PARSE, "%s:%d:menuconfig %s\n", zconf_curname(), zconf_lineno(), (yyvsp[-1].symbol)->name);
}

    break;

  case 36:

    {
	if (current_entry->prompt)
		current_entry->prompt->type = P_MENU;
	else
		zconfprint("warning: menuconfig statement without prompt");
	printd(DEBUG_PARSE, "%s:%d:endconfig\n", zconf_curname(), zconf_lineno());
}

    break;

  case 44:

    {
	menu_set_type((yyvsp[-2].id)->stype);
	printd(DEBUG_PARSE, "%s:%d:type(%u)\n",
		zconf_curname(), zconf_lineno(),
		(yyvsp[-2].id)->stype);
}

    break;

  case 45:

    {
	menu_add_prompt(P_PROMPT, (yyvsp[-2].string), (yyvsp[-1].expr));
	printd(DEBUG_PARSE, "%s:%d:prompt\n", zconf_curname(), zconf_lineno());
}

    break;

  case 46:

    {
	menu_add_expr(P_DEFAULT, (yyvsp[-2].expr), (yyvsp[-1].expr));
	if ((yyvsp[-3].id)->stype != S_UNKNOWN)
		menu_set_type((yyvsp[-3].id)->stype);
	printd(DEBUG_PARSE, "%s:%d:default(%u)\n",
		zconf_curname(), zconf_lineno(),
		(yyvsp[-3].id)->stype);
}

    break;

  case 47:

    {
	menu_add_symbol(P_SELECT, (yyvsp[-2].symbol), (yyvsp[-1].expr));
	printd(DEBUG_PARSE, "%s:%d:select\n", zconf_curname(), zconf_lineno());
}

    break;

  case 48:

    {
	menu_add_symbol(P_IMPLY, (yyvsp[-2].symbol), (yyvsp[-1].expr));
	printd(DEBUG_PARSE, "%s:%d:imply\n", zconf_curname(), zconf_lineno());
}

    break;

  case 49:

    {
	menu_add_expr(P_RANGE, expr_alloc_comp(E_RANGE,(yyvsp[-3].symbol), (yyvsp[-2].symbol)), (yyvsp[-1].expr));
	printd(DEBUG_PARSE, "%s:%d:range\n", zconf_curname(), zconf_lineno());
}

    break;

  case 52:

    {
	const struct kconf_id *id = kconf_id_lookup((yyvsp[-1].string), strlen((yyvsp[-1].string)));
	if (id && id->flags & TF_OPTION) {
		menu_add_option(id->token, (yyvsp[0].string));
		free((yyvsp[0].string));
	}
	else
		zconfprint("warning: ignoring unknown option %s", (yyvsp[-1].string));
	free((yyvsp[-1].string));
}

    break;

  case 53:

    { (yyval.string) = NULL; }

    break;

  case 54:

    { (yyval.string) = (yyvsp[0].string); }

    break;

  case 55:

    {
	struct symbol *sym = sym_lookup((yyvsp[-1].string), SYMBOL_CHOICE);
	sym->flags |= SYMBOL_AUTO;
	menu_add_entry(sym);
	menu_add_expr(P_CHOICE, NULL, NULL);
	free((yyvsp[-1].string));
	printd(DEBUG_PARSE, "%s:%d:choice\n", zconf_curname(), zconf_lineno());
}

    break;

  case 56:

    {
	(yyval.menu) = menu_add_menu();
}

    break;

  case 57:

    {
	if (zconf_endtoken((yyvsp[0].id), T_CHOICE, T_ENDCHOICE)) {
		menu_end_menu();
		printd(DEBUG_PARSE, "%s:%d:endchoice\n", zconf_curname(), zconf_lineno());
	}
}

    break;

  case 65:

    {
	menu_add_prompt(P_PROMPT, (yyvsp[-2].string), (yyvsp[-1].expr));
	printd(DEBUG_PARSE, "%s:%d:prompt\n", zconf_curname(), zconf_lineno());
}

    break;

  case 66:

    {
	if ((yyvsp[-2].id)->stype == S_BOOLEAN || (yyvsp[-2].id)->stype == S_TRISTATE) {
		menu_set_type((yyvsp[-2].id)->stype);
		printd(DEBUG_PARSE, "%s:%d:type(%u)\n",
			zconf_curname(), zconf_lineno(),
			(yyvsp[-2].id)->stype);
	} else
		YYERROR;
}

    break;

  case 67:

    {
	current_entry->sym->flags |= SYMBOL_OPTIONAL;
	printd(DEBUG_PARSE, "%s:%d:optional\n", zconf_curname(), zconf_lineno());
}

    break;

  case 68:

    {
	if ((yyvsp[-3].id)->stype == S_UNKNOWN) {
		menu_add_symbol(P_DEFAULT, (yyvsp[-2].symbol), (yyvsp[-1].expr));
		printd(DEBUG_PARSE, "%s:%d:default\n",
			zconf_curname(), zconf_lineno());
	} else
		YYERROR;
}

    break;

  case 71:

    {
	printd(DEBUG_PARSE, "%s:%d:if\n", zconf_curname(), zconf_lineno());
	menu_add_entry(NULL);
	menu_add_dep((yyvsp[-1].expr));
	(yyval.menu) = menu_add_menu();
}

    break;

  case 72:

    {
	if (zconf_endtoken((yyvsp[0].id), T_IF, T_ENDIF)) {
		menu_end_menu();
		printd(DEBUG_PARSE, "%s:%d:endif\n", zconf_curname(), zconf_lineno());
	}
}

    break;

  case 78:

    {
	menu_add_entry(NULL);
	menu_add_prompt(P_MENU, (yyvsp[-1].string), NULL);
	printd(DEBUG_PARSE, "%s:%d:menu\n", zconf_curname(), zconf_lineno());
}

    break;

  case 79:

    {
	(yyval.menu) = menu_add_menu();
}

    break;

  case 80:

    {
	if (zconf_endtoken((yyvsp[0].id), T_MENU, T_ENDMENU)) {
		menu_end_menu();
		printd(DEBUG_PARSE, "%s:%d:endmenu\n", zconf_curname(), zconf_lineno());
	}
}

    break;

  case 86:

    {
	printd(DEBUG_PARSE, "%s:%d:source %s\n", zconf_curname(), zconf_lineno(), (yyvsp[-1].string));
	zconf_nextfile((yyvsp[-1].string));
	free((yyvsp[-1].string));
}

    break;

  case 87:

    {
	menu_add_entry(NULL);
	menu_add_prompt(P_COMMENT, (yyvsp[-1].string), NULL);
	printd(DEBUG_PARSE, "%s:%d:comment\n", zconf_curname(), zconf_lineno());
}

    break;

  case 89:

    {
	printd(DEBUG_PARSE, "%s:%d:help\n", zconf_curname(), zconf_lineno());
	zconf_starthelp();
}

    break;

  case 90:

    {
	if (current_entry->help) {
		free(current_entry->help);
		zconfprint("warning: '%s' defined with more than one help text -- only the last one will be used",
			   current_entry->sym->name ?: "<choice>");
	}

	/* Is the help text empty or all whitespace? */
	if ((yyvsp[0].string)[strspn((yyvsp[0].string), " \f\n\r\t\v")] == '\0')
		zconfprint("warning: '%s' defined with blank help text",
			   current_entry->sym->name ?: "<choice>");

	current_entry->help = (yyvsp[0].string);
}

    break;

  case 95:

    {
	menu_add_dep((yyvsp[-1].expr));
	printd(DEBUG_PARSE, "%s:%d:depends on\n", zconf_curname(), zconf_lineno());
}

    break;

  case 99:

    {
	menu_add_visibility((yyvsp[0].expr));
}

    break;

  case 101:

    {
	menu_add_prompt(P_PROMPT, (yyvsp[-1].string), (yyvsp[0].expr));
}

    break;

  case 104:

    { (yyval.id) = (yyvsp[-1].id); }

    break;

  case 105:

    { (yyval.id) = (yyvsp[-1].id); }

    break;

  case 106:

    { (yyval.id) = (yyvsp[-1].id); }

    break;

  case 109:

    { (yyval.expr) = NULL; }

    break;

  case 110:

    { (yyval.expr) = (yyvsp[0].expr); }

    break;

  case 111:

    { (yyval.expr) = expr_alloc_symbol((yyvsp[0].symbol)); }

    break;

  case 112:

    { (yyval.expr) = expr_alloc_comp(E_LTH, (yyvsp[-2].symbol), (yyvsp[0].symbol)); }

    break;

  case 113:

    { (yyval.expr) = expr_alloc_comp(E_LEQ, (yyvsp[-2].symbol), (yyvsp[0].symbol)); }

    break;

  case 114:

    { (yyval.expr) = expr_alloc_comp(E_GTH, (yyvsp[-2].symbol), (yyvsp[0].symbol)); }

    break;

  case 115:

    { (yyval.expr) = expr_alloc_comp(E_GEQ, (yyvsp[-2].symbol), (yyvsp[0].symbol)); }

    break;

  case 116:

    { (yyval.expr) = expr_alloc_comp(E_EQUAL, (yyvsp[-2].symbol), (yyvsp[0].symbol)); }

    break;

  case 117:

    { (yyval.expr) = expr_alloc_comp(E_UNEQUAL, (yyvsp[-2].symbol), (yyvsp[0].symbol)); }

    break;

  case 118:

    { (yyval.expr) = (yyvsp[-1].expr); }

    break;

  case 119:

    { (yyval.expr) = expr_alloc_one(E_NOT, (yyvsp[0].expr)); }

    break;

  case 120:

    { (yyval.expr) = expr_alloc_two(E_OR, (yyvsp[-2].expr), (yyvsp[0].expr)); }

    break;

  case 121:

    { (yyval.expr) = expr_alloc_two(E_AND, (yyvsp[-2].expr), (yyvsp[0].expr)); }

    break;

  case 122:

    { (yyval.symbol) = sym_lookup((yyvsp[0].string), 0); free((yyvsp[0].string)); }

    break;

  case 124:

    { (yyval.symbol) = sym_lookup((yyvsp[0].string), SYMBOL_CONST); free((yyvsp[0].string)); }

    break;

  case 125:

    { (yyval.string) = NULL; }

    break;



      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}



void conf_parse(const char *name)
{
	const char *tmp;
	struct symbol *sym;
	int i;

	zconf_initscan(name);

	sym_init();
	_menu_init();

	if (getenv("ZCONF_DEBUG"))
		yydebug = 1;
	yyparse();
	if (yynerrs)
		exit(1);
	if (!modules_sym)
		modules_sym = sym_find( "n" );

	tmp = rootmenu.prompt->text;
	rootmenu.prompt->text = _(rootmenu.prompt->text);
	rootmenu.prompt->text = sym_expand_string_value(rootmenu.prompt->text);
	free((char*)tmp);

	menu_finalize(&rootmenu);
	for_all_symbols(i, sym) {
		if (sym_check_deps(sym))
			yynerrs++;
	}
	if (yynerrs)
		exit(1);
	sym_set_change_count(1);
}

static const char *zconf_tokenname(int token)
{
	switch (token) {
	case T_MENU:		return "menu";
	case T_ENDMENU:		return "endmenu";
	case T_CHOICE:		return "choice";
	case T_ENDCHOICE:	return "endchoice";
	case T_IF:		return "if";
	case T_ENDIF:		return "endif";
	case T_DEPENDS:		return "depends";
	case T_VISIBLE:		return "visible";
	}
	return "<token>";
}

static bool zconf_endtoken(const struct kconf_id *id, int starttoken, int endtoken)
{
	if (id->token != endtoken) {
		zconf_error("unexpected '%s' within %s block",
			id->name, zconf_tokenname(starttoken));
		yynerrs++;
		return false;
	}
	if (current_menu->file != current_file) {
		zconf_error("'%s' in different file than '%s'",
			id->name, zconf_tokenname(starttoken));
		fprintf(stderr, "%s:%d: location of the '%s'\n",
			current_menu->file->name, current_menu->lineno,
			zconf_tokenname(starttoken));
		yynerrs++;
		return false;
	}
	return true;
}

static void zconfprint(const char *err, ...)
{
	va_list ap;

	fprintf(stderr, "%s:%d: ", zconf_curname(), zconf_lineno());
	va_start(ap, err);
	vfprintf(stderr, err, ap);
	va_end(ap);
	fprintf(stderr, "\n");
}

static void zconf_error(const char *err, ...)
{
	va_list ap;

	yynerrs++;
	fprintf(stderr, "%s:%d: ", zconf_curname(), zconf_lineno());
	va_start(ap, err);
	vfprintf(stderr, err, ap);
	va_end(ap);
	fprintf(stderr, "\n");
}

static void yyerror(const char *err)
{
	fprintf(stderr, "%s:%d: %s\n", zconf_curname(), zconf_lineno() + 1, err);
}

static void print_quoted_string(FILE *out, const char *str)
{
	const char *p;
	int len;

	putc('"', out);
	while ((p = strchr(str, '"'))) {
		len = p - str;
		if (len)
			fprintf(out, "%.*s", len, str);
		fputs("\\\"", out);
		str = p + 1;
	}
	fputs(str, out);
	putc('"', out);
}

static void print_symbol(FILE *out, struct menu *menu)
{
	struct symbol *sym = menu->sym;
	struct property *prop;

	if (sym_is_choice(sym))
		fprintf(out, "\nchoice\n");
	else
		fprintf(out, "\nconfig %s\n", sym->name);
	switch (sym->type) {
	case S_BOOLEAN:
		fputs("  bool\n", out);
		break;
	case S_TRISTATE:
		fputs("  tristate\n", out);
		break;
	case S_STRING:
		fputs("  string\n", out);
		break;
	case S_INT:
		fputs("  integer\n", out);
		break;
	case S_HEX:
		fputs("  hex\n", out);
		break;
	default:
		fputs("  ???\n", out);
		break;
	}
	for (prop = sym->prop; prop; prop = prop->next) {
		if (prop->menu != menu)
			continue;
		switch (prop->type) {
		case P_PROMPT:
			fputs("  prompt ", out);
			print_quoted_string(out, prop->text);
			if (!expr_is_yes(prop->visible.expr)) {
				fputs(" if ", out);
				expr_fprint(prop->visible.expr, out);
			}
			fputc('\n', out);
			break;
		case P_DEFAULT:
			fputs( "  default ", out);
			expr_fprint(prop->expr, out);
			if (!expr_is_yes(prop->visible.expr)) {
				fputs(" if ", out);
				expr_fprint(prop->visible.expr, out);
			}
			fputc('\n', out);
			break;
		case P_CHOICE:
			fputs("  #choice value\n", out);
			break;
		case P_SELECT:
			fputs( "  select ", out);
			expr_fprint(prop->expr, out);
			fputc('\n', out);
			break;
		case P_IMPLY:
			fputs( "  imply ", out);
			expr_fprint(prop->expr, out);
			fputc('\n', out);
			break;
		case P_RANGE:
			fputs( "  range ", out);
			expr_fprint(prop->expr, out);
			fputc('\n', out);
			break;
		case P_MENU:
			fputs( "  menu ", out);
			print_quoted_string(out, prop->text);
			fputc('\n', out);
			break;
		default:
			fprintf(out, "  unknown prop %d!\n", prop->type);
			break;
		}
	}
	if (menu->help) {
		int len = strlen(menu->help);
		while (menu->help[--len] == '\n')
			menu->help[len] = 0;
		fprintf(out, "  help\n%s\n", menu->help);
	}
}

void zconfdump(FILE *out)
{
	struct property *prop;
	struct symbol *sym;
	struct menu *menu;

	menu = rootmenu.list;
	while (menu) {
		if ((sym = menu->sym))
			print_symbol(out, menu);
		else if ((prop = menu->prompt)) {
			switch (prop->type) {
			case P_COMMENT:
				fputs("\ncomment ", out);
				print_quoted_string(out, prop->text);
				fputs("\n", out);
				break;
			case P_MENU:
				fputs("\nmenu ", out);
				print_quoted_string(out, prop->text);
				fputs("\n", out);
				break;
			default:
				;
			}
			if (!expr_is_yes(prop->visible.expr)) {
				fputs("  depends ", out);
				expr_fprint(prop->visible.expr, out);
				fputc('\n', out);
			}
		}

		if (menu->list)
			menu = menu->list;
		else if (menu->next)
			menu = menu->next;
		else while ((menu = menu->parent)) {
			if (menu->prompt && menu->prompt->type == P_MENU)
				fputs("\nendmenu\n", out);
			if (menu->next) {
				menu = menu->next;
				break;
			}
		}
	}
}

#include "zconf.lex.c"
#include "util.c"
#include "confdata.c"
#include "expr.c"
#include "symbol.c"
#include "menu.c"
