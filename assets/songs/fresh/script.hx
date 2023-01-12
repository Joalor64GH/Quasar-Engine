import('states.PlayState');

function beatHit(curBeat:Int)
{
	switch (curBeat)
	{
		case 16:
			PlayState.instance.gfSpeed = 2;
		case 48:
			PlayState.instance.gfSpeed = 1;
		case 80:
			PlayState.instance.gfSpeed = 2;
		case 112:
			PlayState.instance.gfSpeed = 1;
	}
}
