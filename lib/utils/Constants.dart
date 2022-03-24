import 'package:flutter/material.dart';

const String BASE_URL = "http://boostmeapi.infibrain.com/api/";

const bool DEVELOPER_MODE=true;

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

// DateFormat viewFormat=DateFormat("dd-MMMM-yyyy");
// DateFormat apiFormat=DateFormat("yyyy-MM-dd");
// DateFormat apiFormat2=DateFormat("yyyyMMdd");

//=========ALL CONSTANTS VALUE FOR THE CODING===========

const String DAILY_WATER="daily_water";
const String WATER_UNIT="water_unit";

const String SELECTED_CONTAINER="selected_container";

const String HIDE_WELCOME_SCREEN="hide_welcome_screen";


const String USER_NAME="user_name";
const String USER_GENDER="user_gender";
const String USER_PHOTO="user_photo";

const String PERSON_HEIGHT="person_height";
const String PERSON_HEIGHT_UNIT="person_height_unit";

const String PERSON_WEIGHT="person_weight";
const String PERSON_WEIGHT_UNIT="person_weight_unit";


const String SET_MANUALLY_GOAL="set_manually_goal";
const String SET_MANUALLY_GOAL_VALUE="set_manually_goal_value";


const String WAKE_UP_TIME="wakeup_time";
const String WAKE_UP_TIME_HOUR="wakeup_time_hour";
const String WAKE_UP_TIME_MINUTE="wakeup_time_minute";

const String BED_TIME="bed_time";
const String BED_TIME_HOUR="bed_time_hour";
const String BED_TIME_MINUTE="bed_time_minute";

const String INTERVAL="interval";

const String REMINDER_OPTION="reminder_option"; // o for auto, 1 for off, 2 for silent
const String REMINDER_VIBRATE="reminder_vibrate";
const String REMINDER_SOUND="reminder_sound";

const String IS_MANUAL_REMINDER="manual_reminder_active";

const String DISABLE_SOUND_WHEN_ADD_WATER="disable_sound_when_add_water";

const String IGNORE_NEXT_STEP="ignore_next_step";


const String IS_ACTIVE="is_active";
const String IS_PREGNANT="is_pregnant";
const String IS_BREATFEEDING="is_breastfeeding";

const String WEATHER_CONSITIONS="weather_conditions";

const double MALE_WATER=35.71;
const double ACTIVE_MALE_WATER=50;
const double DEACTIVE_MALE_WATER=14.29;

const double FEMALE_WATER=28.57;
const double ACTIVE_FEMALE_WATER=40;
const double DEACTIVE_FEMALE_WATER=11.43;

const double PREGNANT_WATER=700;
const double BREASTFEEDING_WATER=700;

const double WEATHER_SUNNY=1;
const double WEATHER_CLOUDY=0.85;
const double WEATHER_RAINY=0.68;
const double WEATHER_SNOW=0.88;


const String APP_SHARE_URL="https://share.html";