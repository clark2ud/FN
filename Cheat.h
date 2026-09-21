#pragma once 
#include "GameFuncs.h"
#include "Offsets.h"
#include "Vector.h"
#include "draw.h"
#include "spoofed.h"
#include "drvkm.h"
float CenterX = GetSystemMetrics(0) / 2 - 1;
float CenterY = GetSystemMetrics(1) / 2 - 1;

typedef struct players {
    uint64_t actor;
    int ia;
    char isDBNO;
    uint64_t mesh;
    uint64_t currentweapon;
    uint64_t aimbotmesh;
    FN_POINTER bonearray;

    int teamid;
    int myteamid;
    uint64_t playerstate;
    uint64_t localplayerstate;
}players;
std::vector<players> entitylist;


namespace Cheat {
    
    void worldloop() {
    
    	while (true) {
           
    		std::vector<players> tmpList;
            

    		pointer::Uworld = KmDrv->Rpm<uint64_t>(virtualaddy + Offsets::UWorld); //+
    		pointer::GameInstance = KmDrv->Rpm<uint64_t>(pointer::Uworld + Offsets::OwningGameInstance); //+
    		pointer::PersistentLevel = KmDrv->Rpm<uint64_t>(pointer::Uworld + Offsets::PersistentLevel);
    		pointer::LocalPlayers = KmDrv->Rpm<uint64_t>(pointer::GameInstance + Offsets::LocalPlayers);
    		pointer::LocalPlayer = KmDrv->Rpm<uint64_t>(pointer::LocalPlayers);
    		pointer::PlayerController = KmDrv->Rpm<uint64_t>(pointer::LocalPlayer + Offsets::PlayerController); //+
    		pointer::LocalPawn = KmDrv->Rpm<uint64_t>(pointer::PlayerController + Offsets::AcknowledgedPawn); //+
    		pointer::PlayerState = KmDrv->Rpm<uint64_t>(pointer::LocalPawn + Offsets::PlayerState);
    		pointer::RootComponent = KmDrv->Rpm<uint64_t>(pointer::LocalPawn + Offsets::RootComponent); //+
            pointer::LocalActorPos = KmDrv->Rpm<Vector3>(pointer::RootComponent + Offsets::LocalActorPos);
            pointer::PlayerCameraManager = KmDrv->Rpm<uintptr_t>(pointer::PlayerController + Offsets::PlayerCameraManager);
           

            Options::Visuals::LobbyESP = false;
            if (!pointer::LocalPawn) Options::Visuals::LobbyESP = true;
            
            /*std::cout << ("Uworld : ") << pointer::Uworld << std::endl;
            std::cout << ("game_instance : ") << pointer::GameInstance << std::endl;
            std::cout << ("persistentlevel : ") << pointer::PersistentLevel << std::endl;
            std::cout << ("local_players : ") << pointer::LocalPlayer << std::endl;
            std::cout << ("local_player : ") << pointer::LocalPlayers << std::endl;
            std::cout << ("player_controller : ") << pointer::PlayerController << std::endl;
            std::cout << ("local_pawn : ") << pointer::LocalPawn << std::endl;
            std::cout << ("player_state : ") << pointer::PlayerState << std::endl;
            std::cout << ("root_comp : ") << pointer::RootComponent << std::endl;*/


    		pointer::ActorCount = KmDrv->Rpm<int>(pointer::PersistentLevel + 0xA0);
            pointer::AActors = KmDrv->Rpm<uintptr_t>(pointer::PersistentLevel + 0x98);
    
    		for (Options::Misc::i = 0; Options::Misc::i < pointer::ActorCount; ++Options::Misc::i) {

    			pointer::CurrentActor = KmDrv->Rpm<uint64_t>(pointer::AActors + Options::Misc::i * 0x8);
                if (!pointer::CurrentActor || pointer::CurrentActor == NULL) { continue; }
    			pointer::CurrentActorMesh = KmDrv->Rpm<uint64_t>(pointer::CurrentActor + Offsets::Mesh);
                if (!pointer::CurrentActorMesh || pointer::CurrentActorMesh == NULL)continue;
    			int curactorid = KmDrv->Rpm<int>(pointer::CurrentActor + 0x18);
                if (!curactorid || curactorid == NULL)continue;

                pointer::PlayerState = KmDrv->Rpm<uint64_t>(pointer::CurrentActor + Offsets::PlayerState);
                pointer::LocalPlayerState = KmDrv->Rpm<uint64_t>(pointer::LocalPawn + Offsets::PlayerState);
                
                int MyTeamId = KmDrv->Rpm<int>(pointer::LocalPlayerState + Offsets::TeamIndex);
                int TeamId = KmDrv->Rpm<int>(pointer::PlayerState + Offsets::TeamIndex);

                char isDBNO = (KmDrv->Rpm<char>(pointer::CurrentActor + 0x832) >> 4) & 1;


                if (KmDrv->Rpm<float>(pointer::CurrentActor + Offsets::ReviveFromDBNOTime) == 10 && pointer::CurrentActorMesh != 0x0 && curactorid != 0x0 && pointer::CurrentActor != 0x0)
                {
                    
                    if (pointer::PlayerState)
                    {
                        players fnlEntity{ };
                        fnlEntity.actor = pointer::CurrentActor;
                        fnlEntity.mesh = pointer::CurrentActorMesh;
                        fnlEntity.myteamid = MyTeamId;
                        fnlEntity.teamid = TeamId;
                        fnlEntity.isDBNO = isDBNO;
                        
                        fnlEntity.playerstate = pointer::PlayerState;
                        fnlEntity.localplayerstate = pointer::LocalPlayerState;
                        tmpList.push_back(fnlEntity);
                    }
                }
    		}
    		entitylist.clear();
    		entitylist = tmpList;
    		Sleep(1000);
    	}
    }



    void actor_loop() {
        auto entityListCopy = entitylist;
        float closestDistance = FLT_MAX;
        DWORD_PTR closestPawn = NULL;

        RGBA orange = { 255, 162, 0,255 };
        char enemies[64];
        char dist[64];
        sprintf_s(dist, ("FPS: %.f\n"), ImGui::GetIO().Framerate);
       
        ImGui::GetBackgroundDrawList()->AddText(ImVec2(1, 1), ImColor(255, 255, 255), dist);

        if (Options::Visuals::ShowFOV && IsInScreen) {

            ImGui::GetBackgroundDrawList()->AddCircle(ImVec2(width / 2, height / 2), Options::Aimbot::fov, IM_COL32(255, 255, 255, 255), 790, 1);
        }


        for (auto entity : entityListCopy)
        {
       

            auto identify = get_bone(0, 0);
            W2S(identify); // will ensure our bool gets called to determine lobby ESP

            uint64_t PlayerState = entity.playerstate;
            uint64_t LocalPlayerState = entity.localplayerstate;
            int TeamId = entity.teamid;
            int MyTeamId = entity.myteamid;
            
            bool IsTeammate = false;
            if (TeamId == MyTeamId)
                IsTeammate = true;
            if (IsTeammate)
                continue;

            if (!entity.playerstate || entity.playerstate == NULL)continue;
            if (pointer::LocalPawn == entity.actor)continue;
            if (!MyTeamId || MyTeamId == NULL)continue;

            FN_VECTOR vHeadBone = get_bone(entity.mesh, 68);
            FN_VECTOR vHeadBoneOut = W2S(vHeadBone);
            FN_VECTOR vRootBone = get_bone(entity.mesh, 0);
            FN_VECTOR vRootBoneOut = W2S(vRootBone);
            FN_VECTOR HeadBox = W2S(FN_VECTOR(vHeadBone.x, vHeadBone.y, vHeadBone.z + 15));
            FN_VECTOR RootBox = W2S(FN_VECTOR(vRootBone.x, vRootBone.y, vRootBone.z - 10));
            float distance = pointer::LocalActorPos.Distance(vHeadBone) / 100.f;

            RGBA Visible = { Options::Colors::espcol[0] * 255, Options::Colors::espcol[1] * 255, Options::Colors::espcol[2] * 255, 255 };
            RGBA Invisible = { Options::Colors::espcolvi[0] * 255, Options::Colors::espcolvi[1] * 255, Options::Colors::espcolvi[2] * 255, 255 };
            RGBA FilledVisible = { Options::Colors::espfilledvis[0] * 255, Options::Colors::espfilledvis[1] * 255, Options::Colors::espfilledvis[2] * 255, 80 };
            RGBA Filled = { Options::Colors::espfilled[0] * 255, Options::Colors::espfilled[1] * 255, Options::Colors::espfilled[2] * 255, 80 };


            auto white = ImColor(255, 255, 255);
            RGBA white2 = { 255,255,255,255 };
            RGBA green = { 0,255,0,255 };

            RGBA red = { 255,0,0,255 };
            RGBA filledgreen = { 0,255,0,20 };
            RGBA filled = { 0,0,0,80 };
            RGBA filledred = { 255,0,0,20 };
            RGBA black = { 0,0,0,255 };

            float BoxHeight = abs(HeadBox.y - vRootBoneOut.y);
            float BoxWidth = BoxHeight * 0.50;

           

            if (distance < Options::Visuals::MaxESPDrawDistance || Options::Visuals::LobbyESP) {


             
                if (Options::Visuals::LineESP) {
                    ImGui::GetBackgroundDrawList()->AddLine(ImVec2(width / 2, height / 1.03), ImVec2(vRootBoneOut.x, vRootBoneOut.y), white, 1.f);
                }
                

                if (!IsInScreen(vHeadBoneOut))
                {
                    continue;
                }


                if (Options::Visuals::BoxESP && IsInScreen(vHeadBoneOut))
                {
                    if (Options::Visuals::Outline)
                    {
                        DrawNormalBox(vRootBoneOut.x - BoxWidth / 2 + 1, HeadBox.y, BoxWidth, BoxHeight, 1, &black);
                        DrawNormalBox(vRootBoneOut.x - BoxWidth / 2 - 1, HeadBox.y, BoxWidth, BoxHeight, 1, &black);
                        DrawNormalBox(vRootBoneOut.x - BoxWidth / 2, HeadBox.y + 1, BoxWidth, BoxHeight, 1, &black);
                        DrawNormalBox(vRootBoneOut.x - BoxWidth / 2, HeadBox.y - 1, BoxWidth, BoxHeight, 1, &black);
                    }
                    if (fisVisible(entity.mesh))
                    {
                        DrawNormalBox(vRootBoneOut.x - (BoxWidth / 2), HeadBox.y, BoxWidth, BoxHeight, 1, &Visible);
                        DrawFilledRect(vRootBoneOut.x - (BoxWidth / 2), HeadBox.y, BoxWidth, BoxHeight, &FilledVisible);
                    }
                    else
                    {
                        DrawNormalBox(vRootBoneOut.x - (BoxWidth / 2), HeadBox.y, BoxWidth, BoxHeight, 1, &Invisible);
                        DrawFilledRect(vRootBoneOut.x - (BoxWidth / 2), HeadBox.y, BoxWidth, BoxHeight, &Filled);
                    }
                }

                if (Options::Visuals::CornerBoxESP && IsInScreen(vHeadBoneOut))
                {

                    if (Options::Visuals::Outline)
                    {
                        DrawCornerBox(vRootBoneOut.x - BoxWidth / 2 + 1, HeadBox.y, BoxWidth, BoxHeight, 1, &black);
                        DrawCornerBox(vRootBoneOut.x - BoxWidth / 2 - 1, HeadBox.y, BoxWidth, BoxHeight, 1, &black);
                        DrawCornerBox(vRootBoneOut.x - BoxWidth / 2, HeadBox.y + 1, BoxWidth, BoxHeight, 1, &black);
                        DrawCornerBox(vRootBoneOut.x - BoxWidth / 2, HeadBox.y - 1, BoxWidth, BoxHeight, 1, &black);
                    }
                    if (fisVisible(entity.mesh))
                    {
                        DrawCornerBox(vRootBoneOut.x - (BoxWidth / 2), HeadBox.y, BoxWidth, BoxHeight, 1, &Visible);
                        DrawFilledRect(vRootBoneOut.x - (BoxWidth / 2), HeadBox.y, BoxWidth, BoxHeight, &FilledVisible);
                    }
                    else
                    {
                        DrawCornerBox(vRootBoneOut.x - (BoxWidth / 2), HeadBox.y, BoxWidth, BoxHeight, 1, &Invisible);
                        DrawFilledRect(vRootBoneOut.x - (BoxWidth / 2), HeadBox.y, BoxWidth, BoxHeight, &Filled);
                    }
                }

                if (Options::Visuals::Distance && IsInScreen(vHeadBoneOut)) {

                    char name[64];
                    sprintf_s(name, "(%.fm)", distance);
                    DrawString(17, HeadBox.x, HeadBox.y - 0, &white2, true, Options::Visuals::OutlineText, name);

                }

            }

            auto dx = vHeadBoneOut.x - (width / 2);
            auto dy = vHeadBoneOut.y - (height / 2);
            auto dist = sqrtf(dx * dx + dy * dy);

            if (dist < Options::Aimbot::fov && dist < closestDistance) {
                
               
                if (Options::Aimbot::SkipKnocked ) {
                    if (!entity.isDBNO) {
                       
                        closestDistance = dist;
                        closestPawn = entity.actor;
                     

                    }
                }
                else
                {
                   
                    closestDistance = dist;
                    closestPawn = entity.actor;

                }  
            }
        }


        if (closestPawn && GETKEY(Options::Aimbot::aimkey))
        {
            if (Options::Aimbot::Aimbot)
            {
                auto AimbotMesh = KmDrv->Rpm<uint64_t>(closestPawn + Offsets::Mesh);
                //Vector3 head1;
                if (Options::Aimbot::vischeck) {

                    if (fisVisible(AimbotMesh)) {
                        Vector3 HeadPosition;
                        Vector3 Head;

                        if (Options::Aimbot::RandomAim) {
                            srand((unsigned)time(NULL));

                            int ran = (rand() % 9);

                            switch (ran)
                            {

                            case 1:
                                //Aimbone head
                                Options::Aimbot::AimBoneInt = 68;
                                break;
                            case 2:
                                //aimbone neck
                                Options::Aimbot::AimBoneInt = 66;
                                break;
                            case 3:
                                //aimbone chest
                                Options::Aimbot::AimBoneInt = 6;
                                break;
                            case 4:
                                //aimbone right hand
                                Options::Aimbot::AimBoneInt = 33;
                                break;
                            }
                            HeadPosition = get_bone(AimbotMesh, Options::Aimbot::AimBoneInt);
                        }
                        else
                        {
                            if (Options::Aimbot::hitbox == 0)
                            {
                                HeadPosition = get_bone(AimbotMesh, 68);
                            }
                            if (Options::Aimbot::hitbox == 1)
                            {
                                HeadPosition = get_bone(AimbotMesh, 66);
                            }
                            if (Options::Aimbot::hitbox == 2)
                            {
                                HeadPosition = get_bone(AimbotMesh, 6);
                            }
                        }

                        Head = W2S(HeadPosition);

                        if (Head.x != 0 || Head.y != 0 || Head.z != 0)
                        {
                            if ((GetDistance(Head.x, Head.y, Head.z, width / 2, height / 2) <= Options::Aimbot::fov))
                            {
                                if (Options::Aimbot::Aimbot)
                                {
                                    mouse::mouse(Head.x, Head.y);
                                }
                            }
                        }
                    }
                }
                else {
                    Vector3 HeadPosition;
                    Vector3 Head;

                    if (Options::Aimbot::RandomAim) {
                        srand((unsigned)time(NULL));

                        int ran = (rand() % 9);

                        switch (ran)
                        {

                        case 1:
                            //Aimbone head
                            Options::Aimbot::AimBoneInt = 68;
                            break;
                        case 2:
                            //aimbone neck
                            Options::Aimbot::AimBoneInt = 66;
                            break;
                        case 3:
                            //aimbone chest
                            Options::Aimbot::AimBoneInt = 6;
                            break;
                        case 4:
                            //aimbone right hand
                            Options::Aimbot::AimBoneInt = 33;
                            break;
                        }
                        HeadPosition = get_bone(AimbotMesh, Options::Aimbot::AimBoneInt);
                    }
                    else
                    {
                        if (Options::Aimbot::hitbox == 0)
                        {
                            HeadPosition = get_bone(AimbotMesh, 68);
                        }
                        if (Options::Aimbot::hitbox == 1)
                        {
                            HeadPosition = get_bone(AimbotMesh, 66);
                        }
                        if (Options::Aimbot::hitbox == 2)
                        {
                            HeadPosition = get_bone(AimbotMesh, 6);
                        }
                    }




                    Head = W2S(HeadPosition);

                    if (Head.x != 0 || Head.y != 0 || Head.z != 0)
                    {
                        if ((GetDistance(Head.x, Head.y, Head.z, width / 2, height / 2) <= Options::Aimbot::fov))
                        {
                            if (Options::Aimbot::Aimbot)
                            {
                                mouse::mouse(Head.x, Head.y);
                            }
                        }
                    }
                }

            }
        }
        else
        {
            closestDistance = FLT_MAX;
            closestPawn = NULL;
        }
        
    }


    
}
