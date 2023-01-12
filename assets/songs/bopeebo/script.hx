import('states.PlayState');

function beatHit(curBeat:Int)
{
	switch (curBeat)
	{
		case 128, 129, 130:
			PlayState.instance.vocals.volume = 0;
	}

	if (curBeat % 8 == 7)
	{
		PlayState.instance.boyfriend.playAnim('hey', true);
		PlayState.instance.boyfriend.specialAnim = true;
	}
}
