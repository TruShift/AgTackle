local TackleKey = 51 -- Change to a number which can be found here: https://wiki.fivem.net/wiki/Controls
local TackleTime = 1000 -- In milliseconds

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedJumping(PlayerPedId()) and IsControlJustReleased(0, TackleKey) then
			if IsPedHuman(PlayerPedID()) == false then
				TriggerEvent('chatMessage', 'Tackle', {255, 255, 255}, 'Animals cant tackle people')
				
				if IsPedInAnyVehicle(PlayerPedId()) then
					TriggerEvent('chatMessage', 'Tackle', {255, 255, 255}, 'A person in a vehicle cant be tackled')
				else
					local ForwardVector = GetEntityForwardVector(PlayerPedId())
					local Tackled = {}
					SetPedToRagdollWithFall(PlayerPedId(), 1500, 2000, 0, ForwardVector, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					while IsPedRagdoll(PlayerPedId()) do
						Citizen.Wait(0)
						for Key, Value in ipairs(GetTouchedPlayers()) do
							if not Tackled[Value] then
								Tackled[Value] = true
								TriggerServerEvent('Tackle:Server:TacklePlayer', GetPlayerServerId(Value), ForwardVector.x, ForwardVector.y, ForwardVector.z, GetPlayerName(PlayerId()))
							end
						end
					end
				end
			end
		end
	end
end)
RegisterNetEvent('Tackle:Client:TacklePlayer')
AddEventHandler('Tackle:Client:TacklePlayer', function(ForwardVectorX, ForwardVectorY, ForwardVectorZ, Tackler)
SetPedToRagdollWithFall(PlayerPedId(), TackleTime, TackleTime, 0, ForwardVectorX, ForwardVectorY, ForwardVectorZ, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
end)