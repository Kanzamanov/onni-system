USE [master]
GO
/****** Object:  Database [OnniDB]    Script Date: 08.06.2025 20:37:18 ******/
CREATE DATABASE [OnniDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'OnniDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\OnniDB.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'OnniDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\OnniDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [OnniDB] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [OnniDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [OnniDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [OnniDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [OnniDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [OnniDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [OnniDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [OnniDB] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [OnniDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [OnniDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [OnniDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [OnniDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [OnniDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [OnniDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [OnniDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [OnniDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [OnniDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [OnniDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [OnniDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [OnniDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [OnniDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [OnniDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [OnniDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [OnniDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [OnniDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [OnniDB] SET  MULTI_USER 
GO
ALTER DATABASE [OnniDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [OnniDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [OnniDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [OnniDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [OnniDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [OnniDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [OnniDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [OnniDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [OnniDB]
GO
/****** Object:  UserDefinedTableType [dbo].[OrderItemType]    Script Date: 08.06.2025 20:37:18 ******/
CREATE TYPE [dbo].[OrderItemType] AS TABLE(
	[ProductId] [int] NULL,
	[Quantity] [int] NULL,
	[PriceAtPurchase] [decimal](10, 2) NULL,
	[Status] [nvarchar](50) NULL
)
GO
/****** Object:  Table [dbo].[Brands]    Script Date: 08.06.2025 20:37:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Brands](
	[BrandId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[ImageUrl] [varchar](max) NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK__Brands__DAD4F05EF49F1F15] PRIMARY KEY CLUSTERED 
(
	[BrandId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Carts]    Script Date: 08.06.2025 20:37:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Carts](
	[CartId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NULL,
	[Quantity] [int] NULL,
	[UserId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CartId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 08.06.2025 20:37:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contact]    Script Date: 08.06.2025 20:37:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contact](
	[ContactId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[Subject] [varchar](200) NULL,
	[Message] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderItem]    Script Date: 08.06.2025 20:37:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderItem](
	[OrderItemId] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[PriceAtPurchase] [decimal](10, 2) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 08.06.2025 20:37:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderId] [int] IDENTITY(1,1) NOT NULL,
	[OrderNo] [varchar](max) NULL,
	[UserId] [int] NULL,
	[PaymentId] [int] NULL,
	[OrderDate] [datetime] NULL,
 CONSTRAINT [PK__Orders__9DD74DBD0D365E99] PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payment]    Script Date: 08.06.2025 20:37:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payment](
	[PaymentId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[CardNo] [varchar](50) NULL,
	[ExpiryDate] [varchar](50) NULL,
	[CvvNo] [int] NULL,
	[Address] [varchar](max) NULL,
	[PaymentMode] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[PaymentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 08.06.2025 20:37:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Description] [varchar](max) NULL,
	[Price] [decimal](18, 2) NULL,
	[Quantity] [int] NULL,
	[ImageUrl] [varchar](max) NULL,
	[BrandId] [int] NULL,
	[CategoryId] [int] NULL,
	[ISActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[ExpirationDate] [date] NULL,
 CONSTRAINT [PK__Products__B40CC6CD4F742970] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 08.06.2025 20:37:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Username] [varchar](50) NULL,
	[PhoneNumber] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[Address] [varchar](max) NULL,
	[Password] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[IsBlocked] [bit] NOT NULL,
 CONSTRAINT [PK__Users__1788CC4CD9E7CC6B] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Brands] ON 

INSERT [dbo].[Brands] ([BrandId], [Name], [ImageUrl], [IsActive], [CreatedDate]) VALUES (1, N'AXIS-Y', N'Images/Brand/3ae15278-30d5-4869-9e49-9154d4279d0b.png', 1, CAST(N'2025-04-19T03:34:22.060' AS DateTime))
INSERT [dbo].[Brands] ([BrandId], [Name], [ImageUrl], [IsActive], [CreatedDate]) VALUES (2, N'COSRX', N'Images/Brand/8edd9900-340e-4b40-bcbd-e84ff1f6fcef.png', 1, CAST(N'2025-04-19T03:35:12.573' AS DateTime))
INSERT [dbo].[Brands] ([BrandId], [Name], [ImageUrl], [IsActive], [CreatedDate]) VALUES (4, N'Beauty of Joseon', N'Images/Brand/fed34079-eed4-4bdb-8cc4-c39b915604c2.png', 1, CAST(N'2025-04-19T03:44:15.100' AS DateTime))
INSERT [dbo].[Brands] ([BrandId], [Name], [ImageUrl], [IsActive], [CreatedDate]) VALUES (5, N'Dr. Ceuracle', N'Images/Brand/499ecc4e-1ce8-4088-a7a8-69bb32beff94.png', 1, CAST(N'2025-04-19T03:44:45.483' AS DateTime))
INSERT [dbo].[Brands] ([BrandId], [Name], [ImageUrl], [IsActive], [CreatedDate]) VALUES (6, N'Dr. Jart+', N'Images/Brand/399b5f9d-9b42-4a9a-bc8b-aef1de29d97c.png', 1, CAST(N'2025-04-19T03:45:25.160' AS DateTime))
INSERT [dbo].[Brands] ([BrandId], [Name], [ImageUrl], [IsActive], [CreatedDate]) VALUES (7, N'Celimax', N'Images/Brand/3e1eb8ab-70f7-4ead-aaed-be0b3c935a82.png', 1, CAST(N'2025-04-19T03:45:45.957' AS DateTime))
INSERT [dbo].[Brands] ([BrandId], [Name], [ImageUrl], [IsActive], [CreatedDate]) VALUES (11, N'House of Hur', N'Images/Brand/f94e597f-f36a-4e26-99fa-6da07c593871.jpg', 1, CAST(N'2025-05-28T00:21:07.307' AS DateTime))
INSERT [dbo].[Brands] ([BrandId], [Name], [ImageUrl], [IsActive], [CreatedDate]) VALUES (12, N'Manyo', N'Images/Brand/8eaad746-9e72-413a-ad55-2e9003e4cdf2.png', 1, CAST(N'2025-05-28T00:22:00.550' AS DateTime))
SET IDENTITY_INSERT [dbo].[Brands] OFF
GO
SET IDENTITY_INSERT [dbo].[Categories] ON 

INSERT [dbo].[Categories] ([CategoryId], [Name], [IsActive], [CreatedDate]) VALUES (9, N'Крем', 1, CAST(N'2025-04-19T00:04:40.963' AS DateTime))
INSERT [dbo].[Categories] ([CategoryId], [Name], [IsActive], [CreatedDate]) VALUES (12, N'Сыворотка', 1, CAST(N'2025-04-19T00:16:17.817' AS DateTime))
INSERT [dbo].[Categories] ([CategoryId], [Name], [IsActive], [CreatedDate]) VALUES (14, N'СПФ', 1, CAST(N'2025-04-22T23:38:56.443' AS DateTime))
INSERT [dbo].[Categories] ([CategoryId], [Name], [IsActive], [CreatedDate]) VALUES (15, N'Тонер', 1, CAST(N'2025-04-22T23:39:06.160' AS DateTime))
INSERT [dbo].[Categories] ([CategoryId], [Name], [IsActive], [CreatedDate]) VALUES (16, N'Гидрофильное масло', 1, CAST(N'2025-04-22T23:39:15.457' AS DateTime))
INSERT [dbo].[Categories] ([CategoryId], [Name], [IsActive], [CreatedDate]) VALUES (18, N'Пенки, гели и муссы', 1, CAST(N'2025-05-22T23:13:02.640' AS DateTime))
SET IDENTITY_INSERT [dbo].[Categories] OFF
GO
SET IDENTITY_INSERT [dbo].[Contact] ON 

INSERT [dbo].[Contact] ([ContactId], [Name], [Email], [Subject], [Message], [CreatedDate]) VALUES (20, N'аы', N'chika1@gmail.com', N'аф', N'аы', CAST(N'2025-05-25T01:13:28.947' AS DateTime))
SET IDENTITY_INSERT [dbo].[Contact] OFF
GO
SET IDENTITY_INSERT [dbo].[OrderItem] ON 

INSERT [dbo].[OrderItem] ([OrderItemId], [OrderId], [ProductId], [Quantity], [PriceAtPurchase], [Status]) VALUES (69, 83, 10, 1, CAST(1090.00 AS Decimal(10, 2)), N'Cancelled')
INSERT [dbo].[OrderItem] ([OrderItemId], [OrderId], [ProductId], [Quantity], [PriceAtPurchase], [Status]) VALUES (70, 84, 10, 1, CAST(1090.00 AS Decimal(10, 2)), N'Delivered')
INSERT [dbo].[OrderItem] ([OrderItemId], [OrderId], [ProductId], [Quantity], [PriceAtPurchase], [Status]) VALUES (71, 85, 10, 1, CAST(1090.00 AS Decimal(10, 2)), N'Delivered')
INSERT [dbo].[OrderItem] ([OrderItemId], [OrderId], [ProductId], [Quantity], [PriceAtPurchase], [Status]) VALUES (72, 86, 10, 1, CAST(1090.00 AS Decimal(10, 2)), N'Cancelled')
INSERT [dbo].[OrderItem] ([OrderItemId], [OrderId], [ProductId], [Quantity], [PriceAtPurchase], [Status]) VALUES (73, 87, 10, 1, CAST(1090.00 AS Decimal(10, 2)), N'Dispatched')
INSERT [dbo].[OrderItem] ([OrderItemId], [OrderId], [ProductId], [Quantity], [PriceAtPurchase], [Status]) VALUES (74, 88, 11, 2, CAST(1050.00 AS Decimal(10, 2)), N'Pending')
INSERT [dbo].[OrderItem] ([OrderItemId], [OrderId], [ProductId], [Quantity], [PriceAtPurchase], [Status]) VALUES (75, 89, 20, 1, CAST(23.00 AS Decimal(10, 2)), N'Delivered')
SET IDENTITY_INSERT [dbo].[OrderItem] OFF
GO
SET IDENTITY_INSERT [dbo].[Orders] ON 

INSERT [dbo].[Orders] ([OrderId], [OrderNo], [UserId], [PaymentId], [OrderDate]) VALUES (83, N'55ae4525713b', 106, 76, CAST(N'2025-05-29T15:07:31.977' AS DateTime))
INSERT [dbo].[Orders] ([OrderId], [OrderNo], [UserId], [PaymentId], [OrderDate]) VALUES (84, N'320598f1242d', 106, 77, CAST(N'2025-05-29T15:08:00.647' AS DateTime))
INSERT [dbo].[Orders] ([OrderId], [OrderNo], [UserId], [PaymentId], [OrderDate]) VALUES (85, N'POSE67071BA6', NULL, 78, CAST(N'2025-05-29T15:12:28.230' AS DateTime))
INSERT [dbo].[Orders] ([OrderId], [OrderNo], [UserId], [PaymentId], [OrderDate]) VALUES (86, N'e405b1c00544', 106, 79, CAST(N'2025-05-29T15:13:21.613' AS DateTime))
INSERT [dbo].[Orders] ([OrderId], [OrderNo], [UserId], [PaymentId], [OrderDate]) VALUES (87, N'c0320928288a', 106, 80, CAST(N'2025-05-29T15:40:28.237' AS DateTime))
INSERT [dbo].[Orders] ([OrderId], [OrderNo], [UserId], [PaymentId], [OrderDate]) VALUES (88, N'5dd7ee53dbf6', 106, 81, CAST(N'2025-06-02T10:27:34.730' AS DateTime))
INSERT [dbo].[Orders] ([OrderId], [OrderNo], [UserId], [PaymentId], [OrderDate]) VALUES (89, N'7dab2270da9f', 106, 82, CAST(N'2025-06-05T00:33:28.757' AS DateTime))
SET IDENTITY_INSERT [dbo].[Orders] OFF
GO
SET IDENTITY_INSERT [dbo].[Payment] ON 

INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (1, N'FAS', N'************2123', N'12/2027', 231, N'FASFA', N'card')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (2, N'', N'', N'', 0, N'AFS', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (3, N'', N'', N'', 0, N'sfs', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (4, N'', N'', N'', 0, N'аы', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (5, N'', N'', N'', 0, N'fs', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (6, N'', N'', N'', 0, N'FS', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (7, N'', N'', N'', 0, N'КЦ', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (8, N'', N'', N'', 0, N'FS', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (9, N'', N'', N'', 0, N'АЫ', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (10, N'', N'', N'', 0, N'АЫ', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (11, N'', N'', N'', 0, N'К', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (12, N'', N'', N'', 0, N'fs', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (13, N'', N'', N'', 0, N'osh', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (14, N'', N'', N'', 0, N'wr', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (15, N'', N'', N'', 0, N's', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (16, N'', N'', N'', 0, N'gs', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (17, N'Chika', N'************2345', N'12/2012', 123, N'врв', N'card')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (18, N'', N'', N'', 0, N'кцк', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (19, N'', N'', N'', 0, N'цкй', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (20, N'', N'', N'', 0, N'Бишкек', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (21, N'', N'', N'', 0, N'афы', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (22, N'', N'', N'', 0, N'аы', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (23, N'', N'', N'', 0, N'пы', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (24, N'', N'', N'', 0, N'фа', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (25, N'', N'', N'', 0, N'fs', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (26, NULL, NULL, NULL, NULL, N'афы', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (27, N'Chika', N'************7685', N'12/2027', 123, N'FAS', N'card')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (28, NULL, NULL, NULL, NULL, N'АЫФ', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (33, NULL, NULL, NULL, NULL, N'FS', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (35, N'Kanzamanov', N'************3456', N'12/2222', 123, N'fasf23', N'card')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (37, NULL, NULL, NULL, NULL, N'аыф', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (41, NULL, NULL, NULL, NULL, N'аы', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (42, NULL, NULL, NULL, NULL, N'ка', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (43, NULL, NULL, NULL, NULL, N'ка', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (44, NULL, NULL, NULL, NULL, N'аы', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (45, NULL, NULL, NULL, NULL, N'фа', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (46, NULL, NULL, NULL, NULL, N'ыа', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (47, NULL, NULL, NULL, NULL, N'кц', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (48, N'Chika', N'************2321', N'12/2222', 123, N'fas', N'card')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (49, NULL, NULL, NULL, NULL, N'аф', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (52, NULL, NULL, NULL, NULL, NULL, N'cashbox')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (53, NULL, NULL, NULL, NULL, NULL, N'cashbox')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (54, NULL, NULL, NULL, NULL, NULL, N'касса')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (55, N'Chika', N'************3232', N'12/2222', 123, N'АЫФ', N'card')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (56, NULL, NULL, NULL, NULL, N'аы', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (57, NULL, NULL, NULL, NULL, N'fs', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (58, NULL, NULL, NULL, NULL, N'fa', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (59, NULL, NULL, NULL, NULL, N'fs', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (60, NULL, NULL, NULL, NULL, NULL, N'cashbox')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (61, NULL, NULL, NULL, NULL, N'fs', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (62, NULL, NULL, NULL, NULL, N'fs', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (63, NULL, NULL, NULL, NULL, N'fsa', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (64, NULL, NULL, NULL, NULL, N'кц', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (65, NULL, NULL, NULL, NULL, N'кц', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (66, NULL, NULL, NULL, NULL, N'аы', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (67, NULL, NULL, NULL, NULL, N'аы', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (68, NULL, NULL, NULL, NULL, N'аы', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (69, NULL, NULL, NULL, NULL, N'аы', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (70, NULL, NULL, NULL, NULL, N'fs', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (71, NULL, NULL, NULL, NULL, N'аы', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (72, NULL, NULL, NULL, NULL, N'аы', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (73, NULL, NULL, NULL, NULL, N'аы', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (74, NULL, NULL, NULL, NULL, N'а', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (75, NULL, NULL, NULL, NULL, N'аы', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (76, NULL, NULL, NULL, NULL, N'кц', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (77, NULL, NULL, NULL, NULL, N'кц', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (78, NULL, NULL, NULL, NULL, NULL, N'cashbox')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (79, NULL, NULL, NULL, NULL, N'аыа', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (80, N'Kanzamanov Chyngyz', N'************7874', N'12/2027', 123, N'da', N'card')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (81, NULL, NULL, NULL, NULL, N'политех', N'cod')
INSERT [dbo].[Payment] ([PaymentId], [Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode]) VALUES (82, NULL, NULL, NULL, NULL, N'аы', N'cod')
SET IDENTITY_INSERT [dbo].[Payment] OFF
GO
SET IDENTITY_INSERT [dbo].[Products] ON 

INSERT [dbo].[Products] ([ProductId], [Name], [Description], [Price], [Quantity], [ImageUrl], [BrandId], [CategoryId], [ISActive], [CreatedDate], [ExpirationDate]) VALUES (10, N'COSRX Advanced Snail 92 All In One Cream', N'Высокоактивный крем для лица с 92% муцина улитки COSRX Advanced Snail 92 All In One Cream комплексно улучшает состояние кожи', CAST(1090.00 AS Decimal(18, 2)), 7, N'Images/Product/c31be358-3010-4f52-8a02-53b4009f5735.jpg', 2, 9, 1, CAST(N'2025-05-24T18:44:49.840' AS DateTime), CAST(N'2025-06-08' AS Date))
INSERT [dbo].[Products] ([ProductId], [Name], [Description], [Price], [Quantity], [ImageUrl], [BrandId], [CategoryId], [ISActive], [CreatedDate], [ExpirationDate]) VALUES (11, N'AXIS-Y Vegan Collagen Eye Serum', N'Веганская сыворотка для глаз AXIS-Y Vegan Collagen Eye Serum — это идеальное решение для борьбы с морщинами, отёчностью и тёмными кругами.
Способ применения: откачайте достаточное количество сыворотки, накачав дозатор один раз. С помощью аппликатора нанесите сыворотку на область вокруг глаз.
Массируйте область, совершая восходящие круговые движения.', CAST(1050.00 AS Decimal(18, 2)), 8, N'Images/Product/56ea02ff-dcc2-4b7b-847a-85c58c9ca055.jpg', 1, 12, 1, CAST(N'2025-05-26T02:16:58.963' AS DateTime), CAST(N'2025-06-08' AS Date))
INSERT [dbo].[Products] ([ProductId], [Name], [Description], [Price], [Quantity], [ImageUrl], [BrandId], [CategoryId], [ISActive], [CreatedDate], [ExpirationDate]) VALUES (14, N'AXIS-Y Dark Spot Correcting Glow Serum', N'Axis-y - Осветляющая сыворотка против пигментации - сыворотка для ухода за кожей лица, которая борется с пигментацией. Формула содержит ниацинамид 5%, обладающий антиоксидантными и осветляющими свойствами. Глутатион помогает осветлить пигментные пятна, а гиалуронат натрия смягчает, повышает упругость и разглаживает эпидермис. Сквалан питает кожу, а аргинин глубоко увлажняет.', CAST(950.00 AS Decimal(18, 2)), 10, N'Images/Product/cfbd1028-8740-491f-b866-f2ebd61dd248.jpg', 1, 12, 1, CAST(N'2025-05-28T00:41:03.290' AS DateTime), CAST(N'2025-06-02' AS Date))
INSERT [dbo].[Products] ([ProductId], [Name], [Description], [Price], [Quantity], [ImageUrl], [BrandId], [CategoryId], [ISActive], [CreatedDate], [ExpirationDate]) VALUES (15, N'Beauty of Joseon Relief Sun: Rice SPF 50+', N'Солнцезащитный крем с пробиотиками Beauty of Joseon Relief Sun : Rice + Probiotics SPF 50+ PA++++ надёжно защищает кожу от разрушающего воздействия УФ-лучей типов UVA и UVB, блокирует синтез меланина и сводит к минимуму риск появления пигментации. Способствует восстановлению микробиоты, укрепляет барьерные функции и отлично увлажняет.', CAST(1090.00 AS Decimal(18, 2)), 10, N'Images/Product/289a27e9-ae17-4453-bd6f-f39e03be2dce.jpg', 4, 14, 1, CAST(N'2025-05-28T00:52:24.810' AS DateTime), CAST(N'2025-06-08' AS Date))
INSERT [dbo].[Products] ([ProductId], [Name], [Description], [Price], [Quantity], [ImageUrl], [BrandId], [CategoryId], [ISActive], [CreatedDate], [ExpirationDate]) VALUES (16, N'Dr.Ceuracle Tea Tree Purifine Cream', N'Крем Dr.Ceuracle Tea Tree Purifine Cream устраняет обезвоженность и увлажняет проблемную и чувствительную кожу, снимает раздражение и успокаивает, питая и смягчая.', CAST(1550.00 AS Decimal(18, 2)), 10, N'Images/Product/d9415d17-3d41-462c-9009-4a7b4b460195.jpeg', 5, 9, 1, CAST(N'2025-05-28T00:55:00.783' AS DateTime), CAST(N'2025-06-08' AS Date))
INSERT [dbo].[Products] ([ProductId], [Name], [Description], [Price], [Quantity], [ImageUrl], [BrandId], [CategoryId], [ISActive], [CreatedDate], [ExpirationDate]) VALUES (17, N'COSRX Low pH Good morning Gel Cleanser', N'Гель для умывания с BHA-кислотами и низким pH COSRX Low pH Good Morning Gel Cleanser', CAST(590.00 AS Decimal(18, 2)), 10, N'Images/Product/6e1fc89d-b1fd-49cd-8577-8bbb1b92832d.jpg', 2, 18, 1, CAST(N'2025-05-28T00:59:32.350' AS DateTime), CAST(N'2025-06-08' AS Date))
INSERT [dbo].[Products] ([ProductId], [Name], [Description], [Price], [Quantity], [ImageUrl], [BrandId], [CategoryId], [ISActive], [CreatedDate], [ExpirationDate]) VALUES (20, N'аы', N'аы', CAST(23.00 AS Decimal(18, 2)), 22, NULL, 7, 15, 0, CAST(N'2025-06-05T00:32:52.207' AS DateTime), CAST(N'2025-07-06' AS Date))
SET IDENTITY_INSERT [dbo].[Products] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([UserId], [Name], [Username], [PhoneNumber], [Email], [Address], [Password], [CreatedDate], [IsBlocked]) VALUES (106, N'Чынгыз', N'Chika', N'+996778743574', N'chika@gmail.com', N'Бишкек', N'12345', CAST(N'2025-05-26T22:36:49.403' AS DateTime), 0)
INSERT [dbo].[Users] ([UserId], [Name], [Username], [PhoneNumber], [Email], [Address], [Password], [CreatedDate], [IsBlocked]) VALUES (114, N'Chika', N'Chika1', N'+996778743574', N'chika1@gmail.com', N'ffa', N'123', CAST(N'2025-06-04T23:16:55.573' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__536C85E4632908D5]    Script Date: 08.06.2025 20:37:18 ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [UQ__Users__536C85E4632908D5] UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__A9D10534DB3B47BA]    Script Date: 08.06.2025 20:37:18 ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [UQ__Users__A9D10534DB3B47BA] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrderItem] ADD  DEFAULT ('Pending') FOR [Status]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [IsBlocked]
GO
ALTER TABLE [dbo].[Carts]  WITH CHECK ADD  CONSTRAINT [FK_Carts_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Carts] CHECK CONSTRAINT [FK_Carts_Products]
GO
ALTER TABLE [dbo].[Carts]  WITH CHECK ADD  CONSTRAINT [FK_Carts_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Carts] CHECK CONSTRAINT [FK_Carts_Users]
GO
ALTER TABLE [dbo].[OrderItem]  WITH CHECK ADD  CONSTRAINT [FK_OrderItem_Orders] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([OrderId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrderItem] CHECK CONSTRAINT [FK_OrderItem_Orders]
GO
ALTER TABLE [dbo].[OrderItem]  WITH CHECK ADD  CONSTRAINT [FK_OrderItem_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
ALTER TABLE [dbo].[OrderItem] CHECK CONSTRAINT [FK_OrderItem_Products]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Payment] FOREIGN KEY([PaymentId])
REFERENCES [dbo].[Payment] ([PaymentId])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Payment]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Users]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Brands] FOREIGN KEY([BrandId])
REFERENCES [dbo].[Brands] ([BrandId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Brands]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Categories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([CategoryId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Categories]
GO
ALTER TABLE [dbo].[OrderItem]  WITH CHECK ADD CHECK  (([Quantity]>(0)))
GO
/****** Object:  StoredProcedure [dbo].[Brand_Crud]    Script Date: 08.06.2025 20:37:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Brand_Crud]
    @Action VARCHAR(10),
    @BrandId INT = NULL,
    @Name VARCHAR(50) = NULL,
    @ImageUrl VARCHAR(MAX) = NULL,
    @IsActive BIT = 0
AS
BEGIN
    SET NOCOUNT ON;

    -- SELECT
    IF @Action = 'SELECT'
    BEGIN
        SELECT * FROM dbo.Brands ORDER BY CreatedDate DESC
    END

	--ACTIVEBRAND
IF @Action = 'ACTIVEBRA'
BEGIN
    SELECT * FROM dbo.Brands WHERE IsActive = 1 ORDER BY Name
END

    -- INSERT
    IF @Action = 'INSERT'
    BEGIN
        INSERT INTO dbo.Brands (Name, ImageUrl, IsActive, CreatedDate)
        VALUES (@Name, @ImageUrl, @IsActive, GETDATE())
    END

    -- UPDATE
    IF @Action = 'UPDATE'
    BEGIN
	DECLARE @UPDATE_IMAGE VARCHAR(20)

    SELECT @UPDATE_IMAGE = 
        (CASE WHEN @ImageUrl IS NULL THEN 'NO' ELSE 'YES' END)

    IF @UPDATE_IMAGE = 'NO'
	 BEGIN
        UPDATE dbo.Brands
        SET Name = @Name,
            IsActive = @IsActive
        WHERE BrandId = @BrandId
    END
	ELSE
    BEGIN
	UPDATE dbo.Brands
	SET Name = @Name, ImageUrl = @ImageUrl, IsActive = @IsActive
        WHERE BrandId = @BrandId
	END
	END
    -- DELETE
    IF @Action = 'DELETE'
    BEGIN
        DELETE FROM dbo.Brands WHERE BrandId = @BrandId
    END

    -- GETBYID
    IF @Action = 'GETBYID'
    BEGIN
        SELECT * FROM dbo.Brands WHERE BrandId = @BrandId
    END
END
GO
/****** Object:  StoredProcedure [dbo].[Cart_Crud]    Script Date: 08.06.2025 20:37:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Cart_Crud]
@Action VARCHAR(10),
@ProductId INT = NULL,
@Quantity INT = NULL,
@UserId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

-- SELECT
    IF @Action = 'SELECT'
    BEGIN
        SELECT c.ProductId,p.Name,p.ImageUrl,p.Price,c.Quantity,c.Quantity AS Qty,p.Quantity AS PrdQty
        FROM dbo.Carts c
        INNER JOIN dbo.Products p ON p.ProductId = c.ProductId
        WHERE c.UserId = @UserId
    END

--INSERT
IF @Action = 'INSERT'
BEGIN
    INSERT INTO dbo.Carts(ProductId, Quantity, UserId)
    VALUES(@ProductId, @Quantity, @UserId)
END

--UPDATE
IF @Action = 'UPDATE'
BEGIN
    UPDATE dbo.Carts
    SET Quantity = @Quantity
    WHERE ProductId = @ProductId AND UserId = @UserId
END
--DELETE
IF @Action = 'DELETE'
BEGIN
    DELETE FROM dbo.Carts
    WHERE ProductId = @ProductId AND UserId = @UserId
END

--GET BY ID (PRODUCTID & USERID)
IF @Action = 'GETBYID'
BEGIN
    SELECT * FROM dbo.Carts
    WHERE ProductId = @ProductId AND UserId = @UserId
END
-- CLEAR (удалить все товары из корзины пользователя)
IF @Action = 'CLEAR'
BEGIN
    DELETE FROM dbo.Carts
    WHERE UserId = @UserId
END

END
GO
/****** Object:  StoredProcedure [dbo].[Category_Crud]    Script Date: 08.06.2025 20:37:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Category_Crud]
    @Action VARCHAR(10),
    @CategoryId INT = NULL,
    @Name VARCHAR(100) = NULL,
    @IsActive BIT = 0
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
	-- SELECT
IF @Action = 'SELECT'
BEGIN
    SELECT * FROM dbo.Categories ORDER BY CreatedDate DESC
END

--ACTIVECATEGORY
IF @Action = 'ACTIVECAT'
BEGIN
    SELECT * FROM dbo.Categories WHERE IsActive = 1 ORDER BY Name
END


-- INSERT
IF @Action = 'INSERT'
BEGIN
    INSERT INTO dbo.Categories (Name, IsActive, CreatedDate)
    VALUES (@Name, @IsActive, GETDATE())
END

-- UPDATE
IF @Action = 'UPDATE'
BEGIN
        UPDATE dbo.Categories
        SET Name = @Name, IsActive = @IsActive
        WHERE CategoryId = @CategoryId
END
-- DELETE
IF @Action = 'DELETE'
BEGIN
    DELETE FROM dbo.Categories WHERE CategoryId = @CategoryId
END

-- GETBYID
IF @Action = 'GETBYID'
BEGIN
    SELECT * FROM dbo.Categories WHERE CategoryId = @CategoryId
END
END
GO
/****** Object:  StoredProcedure [dbo].[ContactSp]    Script Date: 08.06.2025 20:37:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ContactSp]
    @Action VARCHAR(10),
    @ContactId INT = NULL,
    @Name VARCHAR(50) = NULL,
    @Email VARCHAR(50) = NULL,
    @Subject VARCHAR(200) = NULL,
    @Message VARCHAR(MAX) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--INSERT
IF @Action = 'INSERT'
BEGIN
    INSERT INTO dbo.Contact (Name, Email, Subject, Message, CreatedDate)
    VALUES (@Name, @Email, @Subject, @Message, GETDATE())
END

--SELECT
IF @Action = 'SELECT'
BEGIN
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS [SrNo], * FROM dbo.Contact
END

--DELETE BY ADMIN
IF @Action = 'DELETE'
BEGIN
    DELETE FROM dbo.Contact WHERE ContactId = @ContactId
END


END
GO
/****** Object:  StoredProcedure [dbo].[Dashboard]    Script Date: 08.06.2025 20:37:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Dashboard]
    @Action VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Categories
    IF @Action = 'CATEGORY'
    BEGIN
        SELECT COUNT(*) AS Count FROM dbo.Categories
    END

    -- 2. Products
    IF @Action = 'PRODUCT'
    BEGIN
        SELECT COUNT(*) AS Count FROM dbo.Products
    END

    -- 3. Orders
    IF @Action = 'ORDER'
    BEGIN
        SELECT COUNT(DISTINCT OrderId) AS Count FROM OrderItem
    END

    -- 4. Orders Delivered
    IF @Action = 'DELIVERED'
    BEGIN
        SELECT COUNT(*) AS Count FROM dbo.OrderItem WHERE Status = 'Delivered'
    END

    -- 5. Orders Pending
    IF @Action = 'PENDING'
    BEGIN
        SELECT COUNT(*) AS Count FROM dbo.OrderItem WHERE Status IN ('Pending', 'Dispatched')
    END

    -- 6. Users
    IF @Action = 'USER'
    BEGIN
        SELECT COUNT(*) AS Count FROM dbo.Users
    END

    -- 7. Sold Item Cost
    IF @Action = 'SOLDAMOUNT'
BEGIN
    SELECT
        ISNULL(SUM(oi.Quantity * oi.PriceAtPurchase), 0) AS TotalAmount
    FROM OrderItem oi
    WHERE oi.Status = 'Delivered';     
END
    -- 8. Contact
    IF @Action = 'CONTACT'
    BEGIN
        SELECT COUNT(*) AS Count FROM dbo.Contact
    END
	-- 9. Brands
    IF @Action = 'BRAND'
    BEGIN
        SELECT COUNT(*) AS Count FROM dbo.Brands
    END
END
GO
/****** Object:  StoredProcedure [dbo].[Invoice]    Script Date: 08.06.2025 20:37:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Invoice]
    @Action VARCHAR(20),
    @PaymentId INT = NULL,
    @UserId INT = NULL,
    @OrderItemId INT = NULL, -- правильно
    @Status VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- GET INVOICE BY ID
    IF @Action = 'INVOICBYID'
    BEGIN
        SELECT 
            ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS [SrNo],
            o.OrderNo,
            p.Name,
            i.PriceAtPurchase AS Price,
            i.Quantity,
            (i.PriceAtPurchase * i.Quantity) AS TotalPrice,
            o.OrderDate,
            i.Status,
			i.OrderItemId,   -- нужен для CommandArgument="cancel"
			i.ProductId
        FROM Orders o
        INNER JOIN OrderItem i ON i.OrderId = o.OrderId
        INNER JOIN Products p ON p.ProductId = i.ProductId
        WHERE o.PaymentId = @PaymentId AND o.UserId = @UserId
    END

    -- SELECT ORDER HISTORY
    IF @Action = 'ORDHISTORY'
    BEGIN
        SELECT DISTINCT o.PaymentId, p.PaymentMode, p.CardNo
        FROM Orders o
        INNER JOIN Payment p ON p.PaymentId = o.PaymentId
        WHERE o.UserId = @UserId
    END

    -- GET ORDER STATUS
    IF @Action = 'GETSTATUS'
    BEGIN
        SELECT 
            i.OrderItemId,
            o.OrderNo,
			i.Quantity, 
            (i.PriceAtPurchase * i.Quantity) AS TotalPrice,
            i.Status,
            o.OrderDate,
            p.PaymentMode,
            pr.Name
        FROM Orders o
        INNER JOIN OrderItem i ON i.OrderId = o.OrderId
        INNER JOIN Products pr ON pr.ProductId = i.ProductId
        INNER JOIN Payment p ON p.PaymentId = o.PaymentId
    END

    -- GET ORDER STATUS BY ID
    IF @Action = 'STATUSBYID'
    BEGIN
        SELECT OrderItemId, Status 
        FROM OrderItem
        WHERE OrderItemId = @OrderItemId
    END

    -- UPDATE ORDER STATUS
    IF @Action = 'UPDTSTATUS'
    BEGIN
        UPDATE OrderItem
        SET Status = @Status
        WHERE OrderItemId = @OrderItemId 
    END
	/* Псевдокод: добавьте в конец Invoice */

IF @Action = 'CANCEL'
BEGIN
    -- 1. помечаем позицию «Отменён»
    UPDATE OrderItem
    SET    Status = 'Cancelled'
    WHERE  OrderItemId = @OrderItemId       -- <- передаём из кода

    -- 2. возвращаем товар на склад
    /* блок CANCEL в Invoice */

UPDATE p
SET    p.Quantity = p.Quantity + oi.Quantity     -- ← указали p.
FROM   Products  p
JOIN   OrderItem oi ON oi.ProductId = p.ProductId
WHERE  oi.OrderItemId = @OrderItemId;

END

END

GO
/****** Object:  StoredProcedure [dbo].[Product_Crud]    Script Date: 08.06.2025 20:37:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Product_Crud]
    @Action VARCHAR(10),
    @ProductId INT = NULL,
    @Name VARCHAR(100) = NULL,
    @Description VARCHAR(MAX) = NULL,
    @Price DECIMAL(18,2) = 0,
    @Quantity INT = NULL,
    @ImageUrl VARCHAR(MAX) = NULL,
    @CategoryId INT = NULL,
	@BrandId INT = NULL,
	@ExpirationDate DATE = NULL,
    @IsActive BIT = false
AS
BEGIN
    SET NOCOUNT ON;

    -- SELECT
	IF @Action = 'SELECT'
	BEGIN
		SELECT 
			p.*, 
			c.Name AS CategoryName,
			b.Name AS BrandName
		FROM dbo.Products p
		INNER JOIN dbo.Categories c ON c.CategoryId = p.CategoryId
		INNER JOIN dbo.Brands b ON b.BrandId = p.BrandId
		ORDER BY p.CreatedDate DESC
	END

	--ACTIVEPRODUCT
	IF @Action = 'ACTIVEPROD'
BEGIN
    SELECT p.*, c.Name AS CategoryName, b.Name AS BrandName
    FROM Products p
    INNER JOIN Categories c ON p.CategoryId = c.CategoryId
    INNER JOIN Brands b ON p.BrandId = b.BrandId
    WHERE p.IsActive = 1
END



    -- INSERT
    IF @Action = 'INSERT'
    BEGIN
        INSERT INTO dbo.Products (Name, Description, Price, Quantity, ImageUrl, CategoryId, BrandId, IsActive, CreatedDate, ExpirationDate)
        VALUES (@Name, @Description, @Price, @Quantity, @ImageUrl, @CategoryId, @BrandId, @IsActive, GETDATE(), @ExpirationDate)
    END

    -- UPDATE
	IF @Action = 'UPDATE'
	BEGIN
		DECLARE @UPDATE_IMAGE VARCHAR(20)
		SELECT @UPDATE_IMAGE = (CASE WHEN @ImageUrl IS NULL THEN 'NO' ELSE 'YES' END)

		IF @UPDATE_IMAGE = 'NO'
		BEGIN
			UPDATE dbo.Products
			SET Name = @Name, Description = @Description, Price = @Price, Quantity = @Quantity,
            CategoryId = @CategoryId, BrandId = @BrandId, ExpirationDate = @ExpirationDate, IsActive = @IsActive
			WHERE ProductId = @ProductId
		END
		ELSE
		BEGIN
			UPDATE dbo.Products
			SET Name = @Name, Description = @Description, Price = @Price, Quantity = @Quantity,
				ImageUrl = @ImageUrl, CategoryId = @CategoryId, BrandId = @BrandId, ExpirationDate = @ExpirationDate, IsActive = @IsActive
			WHERE ProductId = @ProductId
		END
	END
	-- UPDATE QUANTITY
	IF @Action = 'QTYUPDATE'
	BEGIN
		UPDATE dbo.Products SET Quantity = @Quantity
		WHERE ProductId = @ProductId
	END

	-- DELETE
	IF @Action = 'DELETE'
	BEGIN
		DELETE FROM dbo.Products WHERE ProductId = @ProductId
	END

	-- GET BY ID
	IF @Action = 'GETBYID'
	BEGIN
		SELECT * FROM dbo.Products WHERE ProductId = @ProductId
	END
	-- Получить товары по категории
IF @Action = 'BYCATEGORY'
BEGIN
    SELECT p.*, c.Name AS CategoryName, b.Name AS BrandName
    FROM Products p
    INNER JOIN Categories c ON p.CategoryId = c.CategoryId
    INNER JOIN Brands b ON p.BrandId = b.BrandId
    WHERE p.CategoryId = @CategoryId AND p.IsActive = 1
END
-- Получить товары по бренду
IF @Action = 'BYBRAND'
BEGIN
    SELECT p.*, c.Name AS CategoryName, b.Name AS BrandName
    FROM Products p
    INNER JOIN Categories c ON p.CategoryId = c.CategoryId
    INNER JOIN Brands b ON p.BrandId = b.BrandId
    WHERE p.BrandId = @BrandId AND p.IsActive = 1
END
END
GO
/****** Object:  StoredProcedure [dbo].[Quick_POSSale]    Script Date: 08.06.2025 20:37:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Quick_POSSale]
    @ProductId  INT,
    @Qty        INT,
    @UnitPrice  DECIMAL(18,2)  -- PriceAtPurchase
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Now DATETIME      = GETDATE();
    DECLARE @PaymentId INT, @OrderId INT;

    /* 1. Платёж – заполняем только обязательный PaymentMode */
    INSERT INTO Payment (PaymentMode)
    VALUES ('cashbox');                 -- или 'cash'
    SET @PaymentId = SCOPE_IDENTITY();

    /* 2. заказ */
    DECLARE @OrderNo varchar(12) =
        'POS' + LEFT(REPLACE(NEWID(),'-',''), 9);   -- ← 12-символьный номер

    INSERT INTO Orders (OrderNo, UserId, PaymentId, OrderDate)
    VALUES (@OrderNo, NULL, @PaymentId, @Now);

    SET @OrderId = SCOPE_IDENTITY();

    /* 3. Позиция заказа — сразу Delivered */
    INSERT INTO OrderItem (OrderId, ProductId, Quantity, PriceAtPurchase, Status)
    VALUES (@OrderId, @ProductId, @Qty, @UnitPrice, 'Delivered');
END
GO
/****** Object:  StoredProcedure [dbo].[Save_Orders]    Script Date: 08.06.2025 20:37:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Save_Orders]
    @OrderNo NVARCHAR(50),
    @UserId INT,
    @PaymentId INT,
    @OrderDate DATETIME,
    @tblOrderItems OrderItemType READONLY -- это тип: OrderId, ProductId, Quantity, PriceAtPurchase, Status
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OrderId INT;

-- Сначала вставка в Orders
INSERT INTO Orders (OrderNo, UserId, PaymentId, OrderDate)
VALUES (@OrderNo, @UserId, @PaymentId, @OrderDate);

-- Получаем OrderId
SET @OrderId = SCOPE_IDENTITY();

-- Вставка в OrderItem
INSERT INTO OrderItem (OrderId, ProductId, Quantity, PriceAtPurchase, Status)
SELECT @OrderId, ProductId, Quantity, PriceAtPurchase, Status
FROM @tblOrderItems;

END
GO
/****** Object:  StoredProcedure [dbo].[Save_Payment]    Script Date: 08.06.2025 20:37:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Процедура Save_Payment
CREATE PROCEDURE [dbo].[Save_Payment]
    @Name VARCHAR(100),
    @CardNo VARCHAR(50),
    @ExpiryDate VARCHAR(50),
    @Cvv INT,
    @Address VARCHAR(MAX),
    @PaymentMode VARCHAR(10),
    @InsertedId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Payment (Name, CardNo, ExpiryDate, CvvNo, Address, PaymentMode)
    VALUES (@Name, @CardNo, @ExpiryDate, @Cvv, @Address, @PaymentMode);

    SET @InsertedId = SCOPE_IDENTITY(); -- ← Важно!
END

GO
/****** Object:  StoredProcedure [dbo].[SellingReport]    Script Date: 08.06.2025 20:37:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SellingReport]
    @FromDate DATE,
    @ToDate   DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ROW_NUMBER() OVER (ORDER BY o.OrderDate) AS SrNo,
        o.OrderDate AS SaleDateTime,  
        pr.Name AS ProductName,
        oi.Quantity,
        oi.PriceAtPurchase AS UnitPrice,
        oi.Quantity * oi.PriceAtPurchase AS LineTotal
    FROM   Orders      o
    JOIN   OrderItem   oi  ON oi.OrderId   = o.OrderId
    JOIN   Products    pr  ON pr.ProductId = oi.ProductId
    WHERE  oi.Status = 'Delivered' 
       AND CONVERT(date, o.OrderDate) BETWEEN @FromDate AND @ToDate;
END
GO
/****** Object:  StoredProcedure [dbo].[User_Crud]    Script Date: 08.06.2025 20:37:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[User_Crud]
    @Action VARCHAR(20),
    @UserId INT = NULL,
    @Name VARCHAR(50) = NULL,
    @Username VARCHAR(50) = NULL,
    @PhoneNumber VARCHAR(50) = NULL,
    @Email VARCHAR(50) = NULL,
    @Address VARCHAR(MAX) = NULL,
    @Password VARCHAR(50) = NULL,
	@IsBlocked BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- SELECT FOR LOGIN
    IF @Action = 'SELECT4LOGIN'
    BEGIN
        SELECT * 
        FROM dbo.Users 
        WHERE Username = @Username AND Password = @Password;
    END

    -- SELECT FOR USER PROFILE
    IF @Action = 'SELECT4PROFILE'
    BEGIN
        SELECT * 
        FROM dbo.Users 
        WHERE UserId = @UserId;
    END

    -- INSERT (REGISTRATION)
    IF @Action = 'INSERT'
    BEGIN
        INSERT INTO dbo.Users
        (
            Name,
            Username,
            PhoneNumber,
            Email,
            Address,
            Password,
            CreatedDate
        )
        VALUES
        (
            @Name,
            @Username,
            @PhoneNumber,
            @Email,
            @Address,
            @Password,
            GETDATE()
        )
    END
	-- UPDATE USER PROFILE
IF @Action = 'UPDATE'
    BEGIN
        UPDATE dbo.Users
        SET 
            Name = @Name, 
            Username = @Username, 
            PhoneNumber = @PhoneNumber, 
            Email = @Email, 
            Address = @Address
        WHERE UserId = @UserId
    END
-- SELECT FOR ADMIN
IF @Action = 'SELECT4ADMIN'
BEGIN
    SELECT 
        ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS [SrNo],
        UserId, Name, Username, Email, CreatedDate, IsBlocked
    FROM Users
END
-- TOGGLE BLOCK STATUS
IF @Action = 'BLOCKTOGGLE'
BEGIN
    UPDATE dbo.Users
    SET IsBlocked = CASE WHEN IsBlocked = 1 THEN 0 ELSE 1 END
    WHERE UserId = @UserId
END

-- DELETE BY ADMIN
IF @Action = 'DELETE'
BEGIN
    DELETE FROM dbo.Users WHERE UserId = @UserId
END
END

GO
USE [master]
GO
ALTER DATABASE [OnniDB] SET  READ_WRITE 
GO
