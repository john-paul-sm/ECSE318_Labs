#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <strings.h>
#include <sys/types.h>
#include <sys/stat.h>
#include "circuit.h"

extern	int	yyparse();
extern	FILE	*yyin;

struct gate *first_gate = NULL;
struct gate *last_gate  = NULL;

char **out_names = NULL;
int    n_out     = 0;

char **names   = NULL;
int    n_names = 0;

const char *type_name[] = { "INPUT", "AND", "NAND", "OR", "NOR", "XOR", "XNOR", "BUF", "NOT", "DFF" };

void add_ptr(struct gate ***list, int *n, struct gate *g)
{
  *list = (struct gate **) realloc(*list, (*n + 1) * sizeof(struct gate *));
  (*list)[*n] = g;
  (*n)++;
}

struct gate *find_gate(char *name)
{
  struct gate *g;
  for (g = first_gate; g != NULL; g = g->next)
    if (strcmp(g->name, name) == 0)
      return g;
  return NULL;
}

struct gate *new_gate(char *name, int type)
{
  struct gate *g = (struct gate *) malloc(sizeof(struct gate));

  g->name       = name;
  g->type       = type;
  g->fanin      = NULL;
  g->nfanin     = 0;
  g->fanin_name = NULL;
  g->fanout     = NULL;
  g->nfanout    = 0;
  g->next       = NULL;
  g->level      = -1;
  g->output     = 0;
  g->id         = 0;

  if (last_gate == NULL) first_gate = g;
  else                   last_gate->next = g;
  last_gate = g;
  return g;
}

void name_add(char *s)
{
  names = (char **) realloc(names, (n_names + 1) * sizeof(char *));
  names[n_names++] = s;
}

void name_clear(void)
{
  n_names = 0;
}

void decl_inputs(void)
{
  int i;
  for (i = 0; i < n_names; i++) {
    if (find_gate(names[i]) != NULL)
      fprintf(stderr, "warning: %s declared twice\n", names[i]);
    else
      new_gate(names[i], T_INPUT);
  }
  name_clear();
}

void decl_outputs(void)
{
  int i;
  for (i = 0; i < n_names; i++) {
    out_names = (char **) realloc(out_names, (n_out + 1) * sizeof(char *));
    out_names[n_out++] = names[i];
  }
  name_clear();
}

void decl_gate(int type, char *instance)
{
  struct gate *g;
  int i;

  if (n_names < 2) {
    fprintf(stderr, "gate %s needs an output and at least one input\n", instance);
    name_clear();
    return;
  }
  if (find_gate(names[0]) != NULL) {
    fprintf(stderr, "error: line %s is driven by more than one gate\n", names[0]);
    exit(1);
  }

  g = new_gate(names[0], type);

  g->fanin_name = (char **) malloc((n_names - 1) * sizeof(char *));
  for (i = 1; i < n_names; i++)
    g->fanin_name[i - 1] = names[i];
  g->nfanin = n_names - 1;

  name_clear();
}

void connect_gates(void)
{
  struct gate *g, *src;
  int i, n;

  for (g = first_gate; g != NULL; g = g->next) {
    n = g->nfanin;
    g->nfanin = 0;
    for (i = 0; i < n; i++) {
      src = find_gate(g->fanin_name[i]);
      if (src == NULL) {
        fprintf(stderr, "error: line %s (input of %s) has no driver\n",
                g->fanin_name[i], g->name);
        exit(1);
      }
      add_ptr(&g->fanin,    &g->nfanin,    src);
      add_ptr(&src->fanout, &src->nfanout, g);
    }
  }

  for (i = 0; i < n_out; i++) {
    g = find_gate(out_names[i]);
    if (g == NULL) {
      fprintf(stderr, "error: output %s has no driver\n", out_names[i]);
      exit(1);
    }
    g->output = 1;
  }
}

void add_fanout_buffers(void)
{
  struct gate *g, *f, *b, *stop;
  int k, j;
  char *bname;

  stop = last_gate;
  for (g = first_gate; g != NULL; g = g->next) {
    if (g->nfanout > 1) {
      for (k = 0; k < g->nfanout; k++) {
        f = g->fanout[k];

        bname = (char *) malloc(strlen(g->name) + 12);
        sprintf(bname, "%s_%d", g->name, k + 1);

        b = new_gate(bname, T_BUF);
        add_ptr(&b->fanin,  &b->nfanin,  g);
        add_ptr(&b->fanout, &b->nfanout, f);

        for (j = 0; j < f->nfanin; j++)
          if (f->fanin[j] == g) { f->fanin[j] = b; break; }

        g->fanout[k] = b;
      }
    }
    if (g == stop) break;
  }
}

int levelize(void)
{
  struct gate *g;
  int i, max, ready, changed, left, maxlevel = 0;

  for (g = first_gate; g != NULL; g = g->next)
    g->level = (g->type == T_INPUT || g->type == T_DFF) ? 0 : -1;

  do {
    changed = 0;
    left    = 0;
    for (g = first_gate; g != NULL; g = g->next) {
      if (g->level >= 0) continue;

      ready = 1;
      max   = 0;
      for (i = 0; i < g->nfanin; i++) {
        if (g->fanin[i]->level < 0) { ready = 0; break; }
        if (g->fanin[i]->level > max) max = g->fanin[i]->level;
      }

      if (ready) {
        g->level = max + 1;
        if (g->level > maxlevel) maxlevel = g->level;
        changed = 1;
      } else {
        left++;
      }
    }
  } while (left > 0 && changed);

  if (left > 0) {
    fprintf(stderr, "error: %d gates could not be levelized "
                    "(combinational loop without a DFF)\n", left);
    exit(1);
  }
  return maxlevel;
}

void print_results(int maxlevel)
{
  struct gate *g;
  int i, n, ngates = 0, nin = 0, nout = 0, nff = 0;

  for (g = first_gate; g != NULL; g = g->next) {
    g->id = ngates++;
    if (g->type == T_INPUT) nin++;
    if (g->type == T_DFF)   nff++;
    if (g->output)          nout++;
  }

  printf("Gates per level\n");
  for (i = 0; i <= maxlevel; i++) {
    n = 0;
    for (g = first_gate; g != NULL; g = g->next)
      if (g->level == i) n++;
    printf("  level %2d : %d\n", i, n);
  }

  printf("\nGateType codes:");
  for (i = 0; i <= T_DFF; i++) printf(" %d=%s", i, type_name[i]);
  printf("\n\n");

  printf("%d %d %d %d\n", ngates, nin, nout, nff);
  for (g = first_gate; g != NULL; g = g->next) {
    printf("%d %d %d", g->type, g->output, g->level);
    printf("  %d", g->nfanin);
    for (i = 0; i < g->nfanin; i++)  printf(" %d", g->fanin[i]->id);
    printf("  %d", g->nfanout);
    for (i = 0; i < g->nfanout; i++) printf(" %d", g->fanout[i]->id);
    printf("  %s\n", g->name);
  }
}

int parse_file(vhdl_file)
char *vhdl_file;
{
  yyin = fopen(vhdl_file, "r");
  if (yyin == 0)
    {
      fprintf(stderr, "Could not open vhdl input file (%s)\n", vhdl_file);
      exit(1);
    }

  return yyparse();
}

char *program_path;

/*
 * Return true if the given name corresponds to an executable file
 * in the given directory.
 */
int is_executable (dir, name)
     char *dir, *name;
{
  struct stat buffer;
  char p[2048];

  strcpy (p, dir);
  strcat (p, "/");
  strcat (p, name);
  if (stat (p, &buffer) == -1)
    return 0;
  if (buffer.st_mode & 1)
    return 1;
  return 0;
}


/*
 *	Given the program name (as provided on the command line)
 *	return a path to the corresponding file from which the program
 *	was executed.
 */
char *get_program_path (name)
     char *name;
{
  char *result, *path;

  /* if name has '/' in it, it is good enough for a path */
  if (index (name, '/'))
    {
      result = (char *) malloc (strlen (name) + 1);
      strcpy (result, name);
      return result;
    }

  /* search for name in the directories of the search path */

  /* get the PATH environment variable */
  path = (char *) getenv ("PATH");
  if (!path){
    printf ("getenv failed to get value of PATH");
    exit(0);
  }

  while (*path) {
      char *scan;

      scan = path;
      while (*scan && (*scan != ':')) scan++;
      if (scan == path) {
	     path++;
	     continue;
	  }
      *scan = '\0';
      if (is_executable (path, name)) {
	     result = (char *) malloc (strlen (path) + strlen (name) + 2);
	     strcpy (result, path);
	     strcat (result, "/");
	     strcat (result, name);
	     *scan = ':';
	     return result;
	  }
      *scan = ':';
      path = scan + 1;
  }
  printf ("could not locate executable file for '%s'", name);
  exit(0);
}


int main (argc, argv)
     int argc;
     char **argv;
{
  char *op, *argv0;
  int files;
  int maxlevel;

  argv0 = argv[0];
  program_path = get_program_path (argv0);

  argv++;
  files = 0;
  while (*argv) {
      op = *argv++;
      if (*op != '-') {
	     if (parse_file (op) != 0) {
	         fprintf(stderr, "parse failed for %s\n", op);
	         exit(1);
	     }
	     files++;
	     continue;
	  }
      op++;
   }

  if (files == 0) {
    fprintf(stderr, "usage: a.out circuit.v\n");
    exit(1);
  }

  connect_gates();
  add_fanout_buffers();
  maxlevel = levelize();
  print_results(maxlevel);

  return 0;
}
