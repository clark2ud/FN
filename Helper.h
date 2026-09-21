#pragma once
#include "Includes.h"
#include "Vector.h"
#include <xmmintrin.h>
#include <immintrin.h>
#include "spoofed.h"

namespace SonyDriverHelper {
	class api {
	public:
		static void Init();
		static void MouseMove(float x, float y);
		static bool GetKey(int id);
	};
}

float powf_(float _X, float _Y) {
	return (_mm_cvtss_f32(_mm_pow_ps(_mm_set_ss(_X), _mm_set_ss(_Y))));
}
float sqrtf_(float _X) {
	return (_mm_cvtss_f32(_mm_sqrt_ps(_mm_set_ss(_X))));
}
double GetDistance(double x1, double y1, double z1, double x2, double y2) {
	//return sqrtf(powf_((x2 - x1), 2) + powf_((y2 - y1), 2));
	return sqrtf(powf((x2 - x1), 2) + powf_((y2 - y1), 2));
}


#define FN_POINTER uintptr_t
#define FN_OFFSET ptrdiff_t
#define FN_VECTOR Vector3
#define GETKEY SonyDriverHelper::api::GetKey
#define Init SonyDriverHelper::api::Init
#define MoveMouse SonyDriverHelper::api::MouseMove
#define FN_STORAGE_I int

namespace pointer {
	FN_POINTER Uworld;
	FN_POINTER GameInstance;
	FN_POINTER LocalPlayers;
	FN_POINTER LocalPlayer;
	FN_POINTER LocalPawn;
	FN_POINTER PlayerState;
	FN_POINTER LocalPlayerState;
	FN_POINTER Mesh;
	FN_POINTER RootComponent;
	FN_VECTOR LocalActorPos;
	FN_POINTER PlayerController;
	FN_POINTER PersistentLevel;
	FN_POINTER ULevel;
	FN_POINTER CameraManager;
	FN_POINTER MyObjectID;
	FN_POINTER CurrentActor;
	FN_POINTER PlayerCameraManager;
	FN_POINTER CameraLocation;
	FN_POINTER BoneArray;
	FN_POINTER CurrentActorMesh;
	//DWORD_PTR closestPawn = NULL;
	//float closestDistance = FLT_MAX;
	FN_POINTER AimbotMesh;
	int TeamIndex;
	int ActorCount;
	FN_POINTER AActors;
}

namespace FortCamera {


}


namespace mouse {

	void mouse(float x, float y)
	{
		int Width = GetSystemMetrics(SM_CXSCREEN);
		int Height = GetSystemMetrics(SM_CYSCREEN);


		Vector2 center(Width / 2, Height / 2);
		Vector2 target(0, 0);

		//X Axis
		if (x != 0)
		{
			if (x > center.x)
			{
				target.x = -(center.x - x);
				target.x /= Options::Aimbot::Smooth;
				if (target.x + center.x > center.x * 2)
					target.x = 0;
			}

			if (x < center.x)
			{
				target.x = x - center.x;
				target.x /= Options::Aimbot::Smooth;
				if (target.x + center.x < 0)
					target.x = 0;
			}
		}
		if (y != 0)
		{
			if (y > center.y)
			{
				target.y = -(center.y - y);
				target.y /= Options::Aimbot::Smooth;
				if (target.y + center.y > center.y * 2)
					target.y = 0;
			}

			if (y < center.y)
			{
				target.y = y - center.y;
				target.y /= Options::Aimbot::Smooth;
				if (target.y + center.y < 0)
					target.y = 0;
			}
		}
		if (!target.is_Zero()) {
			SonyDriverHelper::api::MouseMove(target.x, target.y);

		}
	}

}


void MenuWindow(HWND hWindow) {
	SetWindowLong(hWindow, GWL_EXSTYLE, WS_EX_TOOLWINDOW);
	UpdateWindow(hWindow);
}

void GameWindow(HWND hWindow) {
	SetWindowLong(hWindow, GWL_EXSTYLE, WS_EX_LAYERED | WS_EX_TRANSPARENT | WS_EX_TOOLWINDOW);
	UpdateWindow(hWindow);
}
