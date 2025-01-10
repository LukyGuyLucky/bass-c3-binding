# bass-c3-binding
bass.h to bass.c3 binding for the new language c3 ,c3c .

Use at your own risk

There are two examples both converted from the original c samples contest.c ,
contest_0.c3 is keeping the original api name style,ie,bass_apiFunctionHelper();
Inside contest_0.c3 all c api has been converted to c3;

contest_c3.c3 is adapting api names according to  the guideline of c3 language binding writing,
that is,the original api like bass_apiFunctionHelper() will be apiFunctionHelper(),
so that when using module name ,will be bass::apiFunctionHelper().
