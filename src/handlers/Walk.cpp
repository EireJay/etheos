
CLIENT_F_FUNC(Walk)
{
	PacketBuilder reply;

	switch (action)
	{
		case PACKET_MOVEADMIN: // Player walking (admin)
		{
			if (!this->player || !this->player->character || this->player->character->modal) return false;

			if (this->player->character->admin < ADMIN_GUARDIAN)
			{
				return false;
			}
		}
		// no break

		case PACKET_PLAYER: // Player walking (normal)
		case PACKET_MOVESPEC: // Player walking (ghost)
		{
			if (!this->player || !this->player->character || this->player->character->modal) return false;

			int direction = reader.GetChar();
			/*int timestamp = */reader.GetThree();
			int x = reader.GetChar();
			int y = reader.GetChar();

			if (this->player->character->sitting != SIT_STAND)
			{
				return true;
			}

			if (direction >= 0 && direction <= 3)
			{
				if (action == PACKET_MOVEADMIN)
				{
					this->player->character->AdminWalk(direction);
				}
				else
				{
					if (!this->player->character->Walk(direction))
					{
						return true;
					}
				}
			}

			if (this->player->character->x != x || this->player->character->y != y)
			{
				this->player->character->Refresh();
			}

		}
		break;

		default:
			return false;
	}

	return true;
}
