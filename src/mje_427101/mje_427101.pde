

#include <CompactQik2s9v1.h>
#include <NewSoftSerial.h>


// Software serial:
/*
 * Important:
 *     The rxPin goes to the Qik's "TX" pin
 *     The txPin goes to the Qik's "RX" pin
 */
#define txPin 2
#define rxPin 3
#define rstPin 4

// SHARP sensors
#define SHARP_FRONT 14         // Front sensor in A0
#define SHARP_LEFT 15          // Left sensor in A1
#define SHARP_RIGHT 16         // Right sensor in A2
#define SHARP_AREAD_N 10       // Repeat SHARP analogRead N times
#define SHARP_AREAD_DELAY 0    // Delay between readings (ms)
#define MAX_DIST_SIDE 500      // Max. distance considering a side wall
#define MAX_DIST_FRONT 600     // Min. distance considering a front wall

// PID
#define Kp 0.8
#define Ki 0.0
#define Kd 0.0
unsigned long prev_time;     // Previous time
float prev_err;              // Previous error
float correction;            // PID's output

// Instant position variables
float dist_left, dist_right, dist_front;

// Type for positions
enum position { FRONT, LEFT, RIGHT };

// Configuration
#define LANE_WIDTH 500.0    // Distance between walls in the maze
#define DIAMETER 112.0      // Distance between wheels
#define FORESEE 100.0       // Front reading distance for side sensors (from reflective object, supposed centered, to the wheels)
#define PI 3.141592654      // [...]
#define CONFIG_DIST 150     // Distance for sensors' reading in mm
#define CONFIG_PREC 40      // Sets the sensors' reading distance precision in mm (+/-)
float v_max = 0.54;         // Max speed in m/s
int choose_left = 1;        // Left by default
int initialized = 0;        // Boolean variable to know if the robot is already initialized
int just_turned = 0;

// RGB LED
#define LED_RED 9
#define LED_GREEN 10
#define LED_BLUE 11


NewSoftSerial motorSerial =  NewSoftSerial(rxPin, txPin);
CompactQik2s9v1 motor = CompactQik2s9v1(&motorSerial,rstPin);

void setup()
{
	// Serial setup
	Serial.begin(9600);
	motorSerial.begin(9600);

	// Motor setup
	motor.begin();
	motor.stopBothMotors();

	// LED setup
	pinMode(LED_RED, OUTPUT);
	pinMode(LED_GREEN, OUTPUT);
	pinMode(LED_BLUE, OUTPUT);

	// Initialization
//	initialization();
	delay(5000);
}

void loop()
{
	while (way_straight()) move_forward();
	if (way_simple()) turn();
	else solve_node();
}

void turn()
{
	if (dist_left > MAX_DIST_SIDE) turn_left();
	else if (dist_right > MAX_DIST_SIDE) turn_right();
	else if (dist_right < MAX_DIST_SIDE) turn_back();
	just_turned = 1;
}

void turn_right()   // TODO: merge turn_right() and turn_left() into one simple function
{
	set_rgb(0, 0, 255);
	set_speed(LEFT, 127);
	set_speed(RIGHT, 77); // TODO: this should depend on speed... 127*(LANE_WIDTH-DIAMETER)/(LANE_WIDTH+DIAMETER) (?)
	delay(650); // TODO: this should depend on speed... (PI/2*(LANE_WIDTH/2+DIAMETER/2))/(v_max) (?)
}

void turn_right_simple()   // TODO: merge turn_right_simple() and turn_left_simple() into one simple function
{
	// TODO: implement this function
}

void turn_left()
{
	set_rgb(255, 0, 0);
	motor.motor0Forward(77); // TODO: this should depend on speed... 127*(LANE_WIDTH-DIAMETER)/(LANE_WIDTH+DIAMETER) (?)
	motor.motor1Forward(127);
	delay(650); // TODO: this should depend on speed... (PI/2*(LANE_WIDTH/2+DIAMETER/2))/(v_max) (?)
}

void turn_left_simple()   // TODO: merge turn_right_simple() and turn_left_simple() into one simple function
{
	// TODO: implement this function
}

void turn_none()
{
	/*
	 * If there's any side-wall, we should try to maintain the distance.
	 * That should help us for avoid bumping into walls...
	 */
}

void initialization()
{
	unsigned long time = millis();
	int conf;
	do {
		conf = get_config(0);
		if (((millis() - time)/500) % 2 == 0) set_rgb(255, 0, 0);
		else set_rgb(0, 0, 255);
	} while (conf < 2);
	if (conf == 2) choose_left = 1;
	else choose_left = 0;
	while (get_config(1) != 1) {
		if (choose_left) set_rgb(255, 0, 0);
		else set_rgb(0, 0, 255);
	}

	time = millis();
	motor.motor1Forward(127);
	motor.motor0Reverse(127);
	delay(100);
	while (abs((int) get_distance(SHARP_FRONT) - CONFIG_DIST) > CONFIG_PREC + 20);
	delay(100);
	while (abs((int) get_distance(SHARP_FRONT) - CONFIG_DIST) > CONFIG_PREC + 20);
	v_max = 2*PI*DIAMETER/(millis()-time);
	motor.motor1Forward(0);
	motor.motor0Reverse(0);

	for (int i=0; i<4; i++) {
		delay(1000);
		turn_back();
	}

	delay(5000);

	while (get_config(0) != 1) {
		if (((millis() - time)/200) % 2 == 0) set_rgb(0, 255, 0);
		else set_rgb(0, 0, 0);
	}

	set_rgb(0, 255, 0);
	delay(2000);

	initialized = 1;
}

int way_simple()
{
	motor.motor0Forward(127);
	motor.motor1Forward(127);
	if (!just_turned) delay(200); // TODO: this should depend on speed...  FORESEE/v_max

	set_pos();

	if (dist_front < MAX_DIST_FRONT) {
		if (dist_right < MAX_DIST_SIDE || dist_left < MAX_DIST_SIDE)
			return 1;
	} else if (dist_right < MAX_DIST_SIDE && dist_left < MAX_DIST_FRONT) {
			return 1;
	} else return 0;
}

int way_straight()
{
	set_pos();
	if (dist_left < MAX_DIST_SIDE && dist_right < MAX_DIST_SIDE) return 1;
	else return 0;
}

void move_forward()
{
	set_rgb(0, 255, 0);
	correction = pid_output();
	// Fix corrections out of range
	if (correction > 127) correction = 127;
	if (correction < -127) correction = -127;

	if (correction > 0) {
		motor.motor0Forward(127-abs(correction));
		motor.motor1Forward(127);
	} else {
		motor.motor0Forward(127);
		motor.motor1Forward(127-abs(correction));
	}
	if (dist_front < 150) {
		turn_back();
	}
	just_turned = 0;
}

// TODO: implement this function
void solve_node()
{
	// For now, just abort:
	abort();
}

/**
 * @brief Stop program execution.
 *
 * The debug_abort() function may be used for debugging, stopping the
 * program execution for ever.
 *
 * @author Miguel Sánchez de León Peque <msdeleonpeque@gmail.com>
 * @date 2011/02/24
 */
void debug_abort()
{
	debug_pause(0);
	while (1);
}

/**
 * @brief Pause program execution for a while.
 *
 * The debug_pause(int ms) function may be used for debugging, pausing
 * the program execution for ms miliseconds.
 *
 * @author Miguel Sánchez de León Peque <msdeleonpeque@gmail.com>
 * @date 2011/02/24
 */
void debug_pause(int ms)
{
	set_speed(FRONT, 0);
	set_rgb(0, 0, 0);
	delay(ms);
}

/**
 * @brief Gets configuration parameters from one of the sensors.
 *
 * The get_config(uint8_t interrupt) function reads from all sensors
 * until it gets an appropiate response. That means it must read a value
 * at the correct distance and for a few seconds without interruptions.
 *
 * While the sensor is reading, the LED will blink fast with green, red
 * or blue color depending on the selected sensor (front, left or blue
 * respectively). After the reading is confirmed, the LED will stop
 * blinking or the function will end (depending on the value of the
 * parameter "interrupt": 0 to stop blinking, 1 to exit function).
 *
 * @param[in] interrupt Toggle it to 1 if you want to exit get_config() after confirmation.
 * @return Sensor which has confirmed the reading: 1 for FRONT, 2 for LEFT, 3 for RIGHT and 0 for NONE.
 * @author Miguel Sánchez de León Peque <msdeleonpeque@gmail.com>
 * @date 2011/03/22
 */
int get_config(uint8_t interrupt)
{
	unsigned long time = millis();
	for (uint8_t i = 1; i < 4; i++) {
		// Check de appropiate distance
		if (abs((int) get_distance(13 + i) - CONFIG_DIST) < CONFIG_PREC) {
			// Check continuous reading
			while (abs((int) get_distance(13 + i) - CONFIG_DIST) < CONFIG_PREC) {
				if (((millis() - time)/50) % 2 == 0) set_rgb(i==2 ? 255 : 0, i==1 ? 255 : 0, i==3 ? 255 : 0);
				else set_rgb(0, 0, 0);
				// Confirm and return value after 3 seconds
				if (millis() - time > 3000) {
					if (!interrupt) while (abs((int) get_distance(13 + i) - CONFIG_DIST) < CONFIG_PREC) set_rgb(i==2 ? 255 : 0, i==1 ? 255 : 0, i==3 ? 255 : 0);
					return i;
				}
			}
		}
	}
	// Failed to confirm configuration settings
	return 0;
}

/**
 * @brief Returns distance from sensor to the reflective object in mm.
 *
 * The get_distance(uint8_t sensor) function calculates de distance
 * from the specified sensor to the reflective object and returns this
 * value in cm. The distance is calculated this way:
 * @f[
 * distance = 270/(5.0/1023*Vs)
 * @f]
 * Where Vs is the sensor's analog input reading (0V -> 0, 5V -> 1023)
 * and 270 is the constant scale factor (V*mm).
 *
 * @param[in] sensor Name of the sensor's analog input.
 * @return Linearized output of the distance from sensor to the reflective object in mm.
 * @author Miguel Sánchez de León Peque <msdeleonpeque@gmail.com>
 * @date 2011/03/15
 */
float get_distance(uint8_t sensor)
{
    uint8_t i;
    float Vsm = 0; // Average sensor's input voltage
    for (i = 0; i < SHARP_AREAD_N; i++) {
        Vsm += analogRead(sensor);
        delay(SHARP_AREAD_DELAY);
    }
    Vsm /= SHARP_AREAD_N;
    /*
    * In its simplest form, the linearizing equation can be that the
    * distance to the reflective object is approximately equal to a
    * constant scale factor (~270 V*mm) divided by the sensor’s output
    * voltage:
    */
    return 270/(5.0/1023*Vsm); // TODO: Linearize the output dividing the curve in 3-4 pieces (not very important though...)
}

/**
 * @brief Returns PID output
 *
 * The pid_output() function performs a proportional, integral and
 * derivative controller:
 * @f[
 * output = Kp*err + Ki*integral + Kd*derivative
 * @f]
 * For now, we have not implemented the integral and derivative control
 * (Ki = Kd = 0).
 *
 * @return PID output
 * @author Miguel Sánchez de León Peque <msdeleonpeque@gmail.com>
 * @date 2011/03/20
 */
float pid_output()
{
	float err, integral, derivative, output;
	unsigned long dt, time;

	time = millis();

	dt = time - prev_time;

	err = dist_left - dist_right;
	integral += err*dt;
	derivative = (err - prev_err)/dt;

	output = Kp*err + Ki*integral + Kd*derivative;
	prev_time = time;
	prev_err = err;

	return output;
}

/**
 * @brief Set instant position.
 *
 * The set_pos() function reads all the position sensors.
 *
 * @author Miguel Sánchez de León Peque <msdeleonpeque@gmail.com>
 * @date 2011/02/24
 */
void set_pos()
{
	// Set instant position
	dist_left = get_distance(SHARP_LEFT);
	dist_right = get_distance(SHARP_RIGHT);
	dist_front = get_distance(SHARP_FRONT);
}

/**
 * @brief Set RGB LED's colors.
 *
 * The set_rgb(uint8_t red, uint8_t green, uint8_t blue) function is
 * used to change the brightness of the RGB LED's colors.
 *
 * @param[in] red Value for red color: from 0 to 255.
 * @param[in] green Value for green color: from 0 to 255.
 * @param[in] blue Value for blue color: from 0 to 255.
 * @author Miguel Sánchez de León Peque <msdeleonpeque@gmail.com>
 * @date 2011/03/19
 */
void set_rgb(uint8_t red, uint8_t green, uint8_t blue)
{
    analogWrite(LED_RED, red);
    analogWrite(LED_GREEN, green);
    analogWrite(LED_BLUE, blue);
}

/**
 * @brief Set motors' speed.
 *
 * The set_speed(position motor, int speed) function sets the speed of
 * the right (RIGHT), left (LEFT) or both motors (FRONT).
 *
 * @param[in] motor Motor position (left, right or both).
 * @param[in] speed Value for speed.
 * @author Miguel Sánchez de León Peque <msdeleonpeque@gmail.com>
 * @date 2011/04/01
 */
void set_speed(position motor, int speed)
{
	// Fix incorrect values for speed
	speed = (speed > 127) ? 127 : (speed < -127) ? -127 : speed;

	switch (motor) {
		case FRONT :
			if (speed > 0) {
				motor.motor0Forward(speed);
				motor.motor1Forward(speed);
			} else {
				motor.motor0Reverse(speed);
				motor.motor1Reverse(speed);
			}
			break;
		case LEFT :
			if (speed > 0) motor.motor0Forward(speed);
			else motor.motor0Reverse(speed);
			break;
		case RIGHT :
			if (speed > 0) motor.motor1Forward(speed);
			else motor.motor1Reverse(speed);
			break;
		default :
			motor.motor0Forward(0);
			motor.motor1Forward(0);
			break;
	}
}

/**
 * @brief Tells the robot to turn back.
 *
 * The robot will turn back and wait for a brief period of time to
 * continue moving around. This function is supposed to be used only
 * while mapping the maze (the first time).
 *
 * @author Miguel Sánchez de León Peque <msdeleonpeque@gmail.com>
 * @date 2011/03/22
 */
void turn_back()
{
	set_speed(LEFT, 127);
	set_speed(RIGHT, -127);
	delay(PI*DIAMETER/(2*v_max));
	set_speed(FRONT, 0);
	delay(100);
}
