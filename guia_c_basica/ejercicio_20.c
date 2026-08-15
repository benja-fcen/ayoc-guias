int b, c;		// Scope = Global, duración = estática

void f(void)
{
	int b, d;	// Tenemos una situación de shadowing, b enmascara a b global, entonces, ambas variables tienen scope local y duración automática
}

void g(int a)
{
	int c;		// local, automática, enmascara a c global. Para tener un poco más de claridad la voy a llamar c'.
	{
		int a, d;	// local, automática. Puede accederse a c' y a b desde este bloque.
	}
				// no se puede acceder a a y d fuera del bloque anterior.
}