package;

class Rank
{
	public static final gradeArray:Array<String> = [
		'P', 'X', 'X-', 'SS+', 'SS', 'SS-', 'S+', 'S', 'S-', 'A+', 'A', 'A-', 'B', 'C', 'D', 'E'
	];

	public static final unknownGrade:String = 'N/A';

	public static function accuracyToGrade(accuracy:Float):String
	{
		var grade:String = '';

		final wifeConditions:Array<Bool> = [
			accuracy >= 99.99, // P
			accuracy >= 99.98, // X
			accuracy >= 99.95, // X-
			accuracy >= 99.90, // SS+
			accuracy >= 99.80, // SS
			accuracy >= 99.70, // SS-
			accuracy >= 99.50, // S+
			accuracy >= 99, // S
			accuracy >= 96.50, // S-
			accuracy >= 93, // A+
			accuracy >= 90, // A
			accuracy >= 85, // A-
			accuracy >= 80, // B
			accuracy >= 70, // C
			accuracy >= 60, // D
			accuracy <= 60 // E
		];

		for (i in 0...wifeConditions.length)
		{
			if (wifeConditions[i])
			{
				grade = gradeArray[i];
				break;
			}
		}

		if (accuracy <= 0)
			grade = Rank.unknownGrade;

		return grade;
	}

	public static function ratingToHit(rating:String):Float
	{
		var hit:Float = 0;

		switch (rating)
		{
			case 'shit':
				hit = 0.1;
			case 'bad':
				hit = 0.35;
			case 'good':
				hit = 0.75;
			case 'sick':
				hit = 1;
		}

		return hit;
	}
}
