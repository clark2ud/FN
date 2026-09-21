#pragma once
#include <immintrin.h>
#include "Includes.h"
#include "Offsets.h"
#include "Helper.h"
#include "Vector.h"
#include "drvkm.h"


INT32 find_process(LPCTSTR process_name) {
	PROCESSENTRY32 pt;
	HANDLE hsnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
	pt.dwSize = sizeof(PROCESSENTRY32);
	if (Process32First(hsnap, &pt)) {
		do {
			if (!lstrcmpi(pt.szExeFile, process_name)) {
				CloseHandle(hsnap);
				process_id = pt.th32ProcessID;
				return pt.th32ProcessID;
			}
		} while (Process32Next(hsnap, &pt));
	}
	CloseHandle(hsnap);


	return { NULL };
}

struct Camera
{
	Vector3 Location;
	Vector3 Rotation;
	float FOV;
}; Camera vCamera;

struct FMinimalViewInfo
{
	Vector3 Location;
	Vector3 Rotation;
	float FOV;
	float DesiredFOV;
};



void update_camera()
{
	while (true) {



		if (Options::Visuals::LobbyESP)
		{

			auto CameraCache = KmDrv->Rpm<FMinimalViewInfo>(pointer::PlayerCameraManager + 0x1cb0 + 0x10); //LastFrameCameraCachePrivate
			camera::rotation = CameraCache.Rotation;
			camera::location = CameraCache.Location;
			camera::fov = CameraCache.FOV;

		}
		else {
			__int64 v1 = KmDrv->Rpm<__int64>(pointer::LocalPlayer + 0xd0);
			__int64 v9 = KmDrv->Rpm<__int64>(v1 + 0x8);
			__int64 v6 = KmDrv->Rpm<__int64>(pointer::LocalPlayer + 0x70);
			__int64 v7 = KmDrv->Rpm<__int64>(v6 + 0x98);
			__int64 v8 = KmDrv->Rpm<__int64>(v7 + 0xF8);
			uint64_t FGC_Pointerloc = KmDrv->Rpm<uint64_t>(pointer::Uworld + 0x110);
			camera::location = KmDrv->Rpm<Vector3>(FGC_Pointerloc);


			camera::rotation.x = (asin(KmDrv->Rpm<double>(v9 + 0x9C0))) * (180.0 / M_PI);
			camera::rotation.y = KmDrv->Rpm<double>(pointer::RootComponent + 0x148);
			camera::rotation.z = 0;
			camera::zoom = KmDrv->Rpm<float>(v9 + 0x7F0);
			//uintptr_t camera_fov = KmDrv->Rpm<uintptr_t>(virtualaddy + 0xCD93290);
			//KmDrv->Rpm<float>(camera_fov + 0x4CC);
			camera::fov = KmDrv->Rpm<float>(pointer::PlayerController + 0x38C) * 90.f;
			//camera::fov = 80.f / (KmDrv->Rpm<double>(v9 + 0x7F0) / 1.19f);
		}
	}

	/*std::cout << "\n\ncamera::location.x: " << camera::location.x;
	std::cout << "\ncamera::location.y: " << camera::location.y;
	std::cout << "\ncamera::location.z: " << camera::location.z;

	std::cout << "\ncamera::rotation.x: " << camera::rotation.x;
	std::cout << "\ncamera::rotation.y: " << camera::rotation.y;
	std::cout << "\ncamera::rotation.z: " << camera::rotation.z;

	std::cout << "\ncamera::fov: " << camera::fov;*/
}

Vector3 W2S(Vector3 WorldLocation)
{

	D3DMATRIX tempMatrix = Matrix(camera::rotation);

	Vector3 vAxisX = Vector3(tempMatrix.m[0][0], tempMatrix.m[0][1], tempMatrix.m[0][2]);
	Vector3 vAxisY = Vector3(tempMatrix.m[1][0], tempMatrix.m[1][1], tempMatrix.m[1][2]);
	Vector3 vAxisZ = Vector3(tempMatrix.m[2][0], tempMatrix.m[2][1], tempMatrix.m[2][2]);

	Vector3 vDelta = WorldLocation - camera::location;
	Vector3 vTransformed = Vector3(vDelta.Dot(vAxisY), vDelta.Dot(vAxisZ), vDelta.Dot(vAxisX));

	if (vTransformed.z < 1.f)
		vTransformed.z = 1.f;
	Vector3 location = Vector3((width / 2.0f) + vTransformed.x * (((width / 2.0f) / tanf(camera::fov * (float)M_PI / 360.f))) / vTransformed.z, (height / 2.0f) - vTransformed.y * (((width / 2.0f) / tanf(camera::fov * (float)M_PI / 360.f))) / vTransformed.z, 0);

	if (isvectorvalid(location))
	{
		if (IsInScreen(location))
		{
			return location;
		}
	}
}

FN_VECTOR get_bone(const FN_POINTER mesh, const int id)
{

	pointer::BoneArray = KmDrv->Rpm<FN_POINTER>(mesh + Offsets::BoneArray);
	if (pointer::BoneArray == NULL) {
		pointer::BoneArray = KmDrv->Rpm<FN_POINTER>(mesh + Offsets::BoneArray + 0x10);
	}

	FTransform Bone = KmDrv->Rpm<FTransform>(pointer::BoneArray + (id * 0x60));
	FTransform ComponentToWorld = KmDrv->Rpm<FTransform>(mesh + 0x240);

	const D3DMATRIX Matrix = MatrixMultiplication(Bone.ToMatrixWithScale(), ComponentToWorld.ToMatrixWithScale());

	return FN_VECTOR(Matrix._41, Matrix._42, Matrix._43);
}

bool fisVisible(FN_POINTER mesh)
{
	if (!mesh)
		return false;
	float fLastSubmitTime = KmDrv->Rpm<float>(mesh + 0x330);
	float fLastRenderTimeOnScreen = KmDrv->Rpm<float>(mesh + 0x338);

	const float fVisionTick = 0.06f;
	bool bVisible = fLastRenderTimeOnScreen + fVisionTick >= fLastSubmitTime;
	return bVisible;
}
