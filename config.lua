Config = {
	Framework = 2, --[ 1 = ESX / 2 = QBCore / 3 = Other ] Choose your framework

	FrameworkTriggers = {
		notify = '', -- [ ESX = 'esx:showNotification' / QBCore = 'QBCore:Notify' ] Set the notification event, if left blank, default will be used
		object = '', --[ ESX = 'esx:getSharedObject' / QBCore = 'QBCore:GetObject' ] Set the shared object event, if left blank, default will be used (deprecated for QBCore)
		resourceName = '', -- [ ESX = 'es_extended' / QBCore = 'qb-core' ] Set the resource name, if left blank, automatic detection will be performed
	},

    DisableMySQL = false,
    UseAcePermission = nil, -- 'cam',

    CamAccessWhitelist = {
        ['police'] = true
    },

    -- Allow access to certain tagged cameras for given jobs
    -- key in TaggedAccess is the camera tag (can be set via /camadmintool)
    TaggedAccess = {
        ['customs'] = {
            -- jobs allowed to view cameras tagged as "customs"
            ['lscustoms'] = true,
        }
    },
    MaxRecordingLength = 10 * 60 * 1000, -- 10 minutes
    MaxCamRecordingDistance = 100.0,
    HidePlayerWithConceal = false,
    CamTriggerEvents = {
        'rcore_cam:shotsFired',

        -- QBCore
        'qb-bankrobbery:server:callCops',
        'qb-drugs:server:callCops',
        'qb-ifruitstore:server:callCops',
        'qb-storerobbery:server:callCops',
        'qb-armoredtruckheist:server:callCops',

        -- ESX
        'esx_drugs:sellDrug',
        'esx_holdup:robberyStarted',

        -- codesign dispatch
        'cd_dispatch:AddNotification',
        'ps-dispatch:server:notify',

        -- rcore
        'rcore_gangs:playerKilled',
        'rcore_gangs:npcKilled',
        'rcore_gangs:handcuff',
        'rcore_gangs:headbag',
        'rcore_gangs:startSell',
    },
    CamTriggerBlacklistedWeapons = {
        [`WEAPON_STUNGUN`] = true,
    },
    EntityBlinkingInPlayback = true, -- This makes entities in playback fade in/out a little to signify you are viewing a recording
    CameraModels = {
        [`prop_cctv_cam_05a`] = 'prop_cctv_cam_05a',
        [`prop_cctv_cam_03a`] = 'prop_cctv_cam_03a',
        [`prop_cctv_cam_06a`] = 'prop_cctv_cam_06a',
        [`prop_cctv_cam_04c`] = 'prop_cctv_cam_04c',
        [`prop_cctv_cam_01b`] = 'prop_cctv_cam_01b',
        [`prop_cctv_cam_01a`] = 'prop_cctv_cam_01a',
        [`prop_cctv_cam_04a`] = 'prop_cctv_cam_04a',
        [`prop_cctv_cam_02a`] = 'prop_cctv_cam_02a',
        [`prop_cctv_cam_04b`] = 'prop_cctv_cam_04b',
        [`prop_cctv_cam_07a`] = 'prop_cctv_cam_07a',
        [`prop_cctv_pole_02`] = 'prop_cctv_pole_02',
        [`prop_cctv_pole_03`] = 'prop_cctv_pole_03',
        [`prop_cctv_pole_04`] = 'prop_cctv_pole_04',
        [`v_serv_securitycam_1a`] = 'v_serv_securitycam_1a',
        [`prop_cctv_pole_01a`] = 'prop_cctv_pole_01a',
        [`ba_prop_battle_cctv_cam_01b`] = 'ba_prop_battle_cctv_cam_01b',
        [`v_serv_securitycam_03`] = 'v_serv_securitycam_03',
        [`ba_prop_battle_cctv_cam_01a`] = 'ba_prop_battle_cctv_cam_01a',
    },
    CameraModelOffsets = {
        [`prop_cctv_pole_02`] = {
            start = vector3(0.15, -0.65, 6.2),
            target = vector3(0.35, -1.0, 6.0),
        },
        [`prop_cctv_pole_03`] = {
            start = vector3(0.9, 0.25, 6.1),
            target = vector3(1.8, 0.8, 5.5),
        },
        [`prop_cctv_pole_04`] = {
            start = vector3(-0.8, -0.26, 4.4),
            target = vector3(-1.6, -0.70, 4.0),
        },
        [`prop_cctv_cam_01a`] = {
            start = vector3(0.15, -0.65, 0.2),
            target = vector3(0.35, -1.0, 0.0),
        },
        [`prop_cctv_cam_03a`] = {
            start = vector3(-0.5, -0.5, 0.3),
            target = vector3(-1.0, -1.0, 0.1),
        },
        [`prop_cctv_cam_06a`] = {
            start = vector3(0.0, -0.2, -0.35),
            target = vector3(0.0, -1.0, -0.7),
        },
        [`prop_cctv_cam_01b`] = {
            start = vector3(-0.22, -0.75, 0.15),
            target = vector3(-0.44, -1.122, -0.05),
        },
        [`prop_cctv_cam_02a`] = {
            start = vector3(0.18, -0.3, -0.08),
            target = vector3(0.72, -1.2, -0.4),
        },
        [`prop_cctv_cam_04a`] = {
            start = vector3(0.0, -0.9, 0.7),
            target = vector3(0.0, -2.0, 0.0),
        },
        [`prop_cctv_cam_04b`] = {
            start = vector3(0.0, -0.8, 0.6),
            target = vector3(0.0, -2.0, 0.0),
        },
        [`prop_cctv_cam_04c`] = {
            start = vector3(0.0, -0.4, -0.3),
            target = vector3(0.0, -2.0, -1.2),
        },
        [`prop_cctv_cam_05a`] = {
            start = vector3(0.0, -0.3, -0.5),
            target = vector3(0.0, -2.0, -1.2),
        },
        [`prop_cctv_cam_07a`] = {
            start = vector3(0.0, -0.4, -0.3),
            target = vector3(0.0, -2.0, -1.2),
        },
        [`v_serv_securitycam_03`] = {
            start = vector3(0.15, -0.65, 0.2),
            target = vector3(0.35, -1.0, 0.0),
        },
        [`v_serv_securitycam_1a`] = {
            start = vector3(0.15, -0.65, 0.2),
            target = vector3(0.35, -1.0, 0.0),
        },
        [`prop_cctv_pole_01a`] = {
            start = vector3(-0.6, -0.3, 7.2),
            target = vector3(-1.6, -0.8, 6.8),
        },
        [`ba_prop_battle_cctv_cam_01b`] = {
            start = vector3(-0.4, -0.4, -0.1),
            target = vector3(-0.9, -0.4, -0.5),
        },
        [`ba_prop_battle_cctv_cam_01a`] = {
            start = vector3(0.4, -0.4, -0.1),
            target = vector3(0.9, -0.4, -0.5),
        },
    },
    -- Allowed jobs (police, etc.) can deposit/withdraw recordings, everyone can view
    PublicViewPlaces = {
        MRPD_PUBLIC = {
            pos = vector3(436.86, -993.16, 29.68),
            folders = {
                {
                    name = 'evidence_1',
                    label = 'Evidence #1',
                },
            },
        },
    },
    -- Only accessible by allowed jobs (police, etc.)
    RecordingStorages = {
        -- MECHANIC_STORAGE = {
        --     -- if job is defined, it's only for the given job
        --     -- otherwise it's for police
        --     job = 'lscustoms',
        --     pos = vector3(444.06, -984.14, 29.91),
        --     folders = {
        --         {
        --             name = 'evidence_1',
        --             label = 'Evidence #1',
        --         },
        --     }
        -- },
        MRPD = {
            pos = vector3(443.12, -976.34, 29.71),
            folders = {
                {
                    name = 'evidence_1',
                    label = 'Evidence #1',
                },
                {
                    name = 'evidence_2',
                    label = 'Evidence #2',
                },
                {
                    name = 'evidence_3',
                    label = 'Evidence #3',
                },
                {
                    name = 'evidence_4',
                    label = 'Evidence #4',
                },
                {
                    name = 'evidence_5',
                    label = 'Evidence #5',
                },
                {
                    name = 'evidence_6',
                    label = 'Evidence #6',
                },
                {
                    name = 'evidence_7',
                    label = 'Evidence #7',
                },
                {
                    name = 'evidence_8',
                    label = 'Evidence #8',
                },
                {
                    name = 'evidence_9',
                    label = 'Evidence #9',
                },
                {
                    minGrade = 4,
                    name = 'evidence_10',
                    label = 'Evidence #10',
                },
            }
        },
    },
    Control = {
        CAM_PAUSE = {
            key = 191,
            name = 'INPUT_FRONTEND_RDOWN',
            label = 'Pause',
        },
        CAM_PLAY = {
            key = 191,
            name = 'INPUT_FRONTEND_RDOWN',
            label = 'Play',
        },
        CAM_REWIND = {
            key = 174,
            name = 'INPUT_CELLPHONE_LEFT',
            label = 'Rewind',
        },
        CAM_FAST_FORWARD = {
            key = 175,
            name = 'INPUT_CELLPHONE_RIGHT',
            label = 'Fast Forward',
        },
        CAM_NEXT_CAM = {
            key = 172,
            name = 'INPUT_CELLPHONE_UP',
            label = 'Next Cam',
        },
        CAM_PREV_CAM = {
            key = 173,
            name = 'INPUT_CELLPHONE_DOWN',
            label = 'Prev. Cam',
        },
        CAM_BACK = {
            key = 194,
            name = 'INPUT_FRONTEND_RRIGHT',
            label = 'Exit Recording',
        },
    },
    Text = {
        CAMPLAY_ALREADY_PLAYING = 'You are already playing a recording',
        RECORDING_TRANSFERED = 'Recording was transfered',
        OPEN_RECORDINGS = '~INPUT_PICKUP~ Open recordings',
        CAM_RECORDINGS = 'Cam Recordings',
        STOP_RECORDING = 'Stop recording',
        RECORDING_PROCESSING = 'Recording is being processed',
        PLAY = 'Play',
        TAKE = 'Take',
        STORE = 'Store',
        GIVE = 'Give',
        SECURITY_GROUP = 'Security Group',
        NO_RECORDINGS = 'No recordings',
        PLAYER = 'Player',
        LOADING_RECORDING = '   Loading recording...',
        OPEN_REC_STORAGE = '~INPUT_PICKUP~ Open recording storage',
        STORED_RECORDINGS = 'Stored recordings',
        YOUR_RECORDINGS = 'Your recordings',
    }
}