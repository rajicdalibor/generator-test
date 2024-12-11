import { FC, useCallback, useEffect, useState } from 'react';
import { displayUserName, UserAccount } from '../../models/user-account';
import UserAccountService from '../../services/user-account.service';
import { DataGrid, GridColDef } from '@mui/x-data-grid';
import CustomLink from '../../components/CustomLink';
import { Divider, Stack, Typography } from '@mui/material';
import { ROUTES } from '../../navigation/routes';
import { format } from 'date-fns';
import { standardDateTimeFormat } from '../../utils/date-time.utils';

export const UsersPage: FC = () => {
  const [users, setUsers] = useState<UserAccount[]>([]);

  useEffect(() => {
    const userAccountService = new UserAccountService();
    userAccountService.getUsers().then((users) => {
      setUsers(users);
    });
  }, []);

  const renderUsersTable = useCallback(() => {
    const rows = users.map((user) => ({
      id: user.id,
      name: displayUserName(user),
      email: user.email,
      lastKnownActivity: user.lastKnownActivity,
      installedAppVersion: user.installedAppVersion,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    }));

    const columns: GridColDef<(typeof rows)[number]>[] = [
      {
        field: 'id',
        headerName: 'ID',
        sortable: false,
        flex: 2,
        renderCell: (params) => {
          return (
            <CustomLink
              text={params.row.id}
              to={ROUTES.USERS_DETAILS.replace(':id', params.row.id)}
            />
          );
        },
      },
      {
        field: 'name',
        headerName: 'Name',
        type: 'string',
        sortable: false,
        flex: 2,
      },
      {
        field: 'email',
        headerName: 'Email',
        sortable: false,
        type: 'custom',
        flex: 2,
        renderCell: (params) => {
          return <CustomLink text={params.row.email ?? ''} to={`mailto:${params.row.email}`} />;
        },
      },
      {
        field: 'lastKnownActivity',
        headerName: 'Last known activity',
        type: 'string',
        sortable: true,
        flex: 2,
        renderCell: (params) => {
          if (params.row.lastKnownActivity) {
            return format(params.row.lastKnownActivity.toDate(), standardDateTimeFormat);
          }
        },
      },
      {
        field: 'installedAppVersion',
        headerName: 'Installed app version',
        type: 'string',
        sortable: true,
        flex: 1,
      },
      {
        field: 'createdAt',
        headerName: 'Created at',
        type: 'string',
        sortable: true,
        flex: 2,
        renderCell: (params) => {
          if (params.row.createdAt) {
            return format(params.row.createdAt.toDate(), standardDateTimeFormat);
          }
        },
      },
      {
        field: 'updatedAt',
        headerName: 'Updated at',
        type: 'string',
        sortable: true,
        flex: 2,
        renderCell: (params) => {
          if (params.row.updatedAt) {
            return format(params.row.updatedAt.toDate(), standardDateTimeFormat);
          }
        },
      },
    ];

    return (
      <DataGrid
        sx={{ marginTop: 2 }}
        rows={rows}
        columns={columns}
        initialState={{
          pagination: {
            paginationModel: {
              pageSize: 20,
            },
          },
          sorting: {
            sortModel: [
              {
                field: 'createdAt',
                sort: 'desc',
              },
            ],
          },
        }}
        pageSizeOptions={[20]}
        disableRowSelectionOnClick
      />
    );
  }, [users]);

  return (
    <Stack direction={'column'} padding={2}>
      <Typography variant="h4">Users</Typography>
      <Divider sx={{ width: '100%', marginBottom: 2, marginTop: 2 }} />
      {renderUsersTable()}
    </Stack>
  );
};
